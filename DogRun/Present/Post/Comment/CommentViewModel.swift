//
//  CommentViewModel.swift
//  DogRun
//
//  Created by 이재희 on 5/2/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CommentViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    var postId: String = ""
    var comments = BehaviorRelay<[Comment]>(value: [])
    
    struct Input {
        let textInput: ControlProperty<String?>
        let sendButtonTap: ControlEvent<Void>
        let deleteButtonTap: PublishRelay<Int>
    }
    
    struct Output {
        let comments: Driver<[Comment]>
        let isTextEmpty: Driver<Bool>
        let commentSuccess: PublishRelay<Void>
        let commentFailure: PublishRelay<DRError>
        let deleteSuccess: PublishRelay<Void>
        let deleteFailure: PublishRelay<DRError>
    }
    
    func transform(input: Input) -> Output {
        let commentSuccess = PublishRelay<Void>()
        let commentFailure = PublishRelay<DRError>()
        
        let deleteSuccess = PublishRelay<Void>()
        let deleteFailure = PublishRelay<DRError>()
        
        let textInput = input.textInput.orEmpty.share()
        
        let isTextEmpty = textInput
            .map { $0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        input.sendButtonTap
            .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .withLatestFrom(textInput)
            .flatMapLatest { [weak self] value in
                return NetworkManager.request2(type: Comment.self, router: CommentRouter.uploadComment(postId: self?.postId ?? "", model: .init(content: value)))
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    owner.comments.accept([success] + owner.comments.value)
                    commentSuccess.accept(())
                case .failure(let failure):
                    commentFailure.accept(failure)
                }
            }
            .disposed(by: disposeBag)
        
        input.deleteButtonTap
            .map { [self] in
                (postId, comments.value[$0].comment_id)
            }
            .flatMap { value in
                return NetworkManager.requestVoid(router: CommentRouter.deleteComment(postId: value.0, commentId: value.1))
                    .map { result in (result, value.1) }
            }
            .bind(with: self) { owner, response in
                switch response.0 {
                case .success(_):
                    owner.comments.accept(owner.comments.value.filter { $0.comment_id != response.1 })
                case .failure(let failure):
                    deleteFailure.accept(failure)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            comments: comments.asDriver(onErrorJustReturn: []),
            isTextEmpty: isTextEmpty, 
            commentSuccess: commentSuccess,
            commentFailure: commentFailure,
            deleteSuccess: deleteSuccess,
            deleteFailure: deleteFailure
        )
    }
}
