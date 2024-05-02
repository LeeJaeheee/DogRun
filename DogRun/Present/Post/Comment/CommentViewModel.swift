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
    
    var productId: String = ""
    var comments = BehaviorRelay<[Comment]>(value: [])
    
    struct Input {
        let textInput: ControlProperty<String?>
        let sendButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let comments: Driver<[Comment]>
        let isTextEmpty: Driver<Bool>
        let commentFailure: PublishRelay<DRError>
    }
    
    func transform(input: Input) -> Output {
        let commentFailure = PublishRelay<DRError>()
        let textInput = input.textInput.orEmpty.share()
        
        let isTextEmpty = textInput
            .map { $0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        input.sendButtonTap
            .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .withLatestFrom(textInput)
            .flatMapLatest { [weak self] value in
                return NetworkManager.request2(type: Comment.self, router: CommentRouter.uploadComment(postId: self?.productId ?? "", model: .init(content: value)))
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    owner.comments.accept([success] + owner.comments.value)
                case .failure(let failure):
                    commentFailure.accept(failure)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            comments: comments.asDriver(onErrorJustReturn: []),
            isTextEmpty: isTextEmpty,
            commentFailure: commentFailure
        )
    }
}
