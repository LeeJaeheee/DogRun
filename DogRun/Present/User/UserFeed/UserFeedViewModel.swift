//
//  UserFeedViewModel.swift
//  DogRun
//
//  Created by 이재희 on 5/1/24.
//

import Foundation
import RxSwift
import RxCocoa

final class UserFeedViewModel: ViewModelType {
    enum UserType {
        case specific
        case all
    }
    
    var disposeBag = DisposeBag()
    
    var usertype = UserType.all
    var userId = UserDefaultsManager.userId
    
    struct Input {
        let loadTrigger: BehaviorRelay<Void>
        let fetchMoreDatas: ControlEvent<[IndexPath]>
    }
    
    struct Output {
        let posts: Driver<[PostResponse]>
        let fetchFailure: PublishRelay<DRError>
//        let refreshControlAction: PublishSubject<Void>
//        let refreshControlCompelted: PublishSubject<Void>
//        let isLoadingSpinnerAvaliable: PublishSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        let postsRelay = BehaviorRelay<[PostResponse]>(value: [])
        let nextCursor = BehaviorRelay<String?>(value: nil)
        let fetchFailureRelay = PublishRelay<DRError>()
        let isLoadingSpinnerAvaliable = PublishRelay<Bool>()
        
        switch usertype {
        case .specific:
            input.loadTrigger
                .flatMapLatest { _ in
                    isLoadingSpinnerAvaliable.accept(true)
                    return NetworkManager.request2(type: PostsResponse.self, router: PostRouter.fetchUserPost(id: self.userId, query: .init(next: nextCursor.value, limit: nil, product_id: "dr_sns", hashTag: nil)))
                }
                .bind(with: self) { owner, response in
                    switch response {
                    case .success(let success):
                        //dump(success.data)
                        var updatedPosts = postsRelay.value
                        updatedPosts.append(contentsOf: success.data)
                        postsRelay.accept(updatedPosts)
                        nextCursor.accept(success.next_cursor)
                    case .failure(let failure):
                        fetchFailureRelay.accept(failure)
                    }
                    isLoadingSpinnerAvaliable.accept(false)
                }
                .disposed(by: disposeBag)
        case .all:
            input.loadTrigger
                .flatMapLatest { _ in
                    isLoadingSpinnerAvaliable.accept(true)
                    return NetworkManager.request2(type: PostsResponse.self, router: PostRouter.fetchPost(query: .init(next: nextCursor.value, limit: nil, product_id: "dr_sns", hashTag: nil)))
                    
                }
                .bind(with: self) { owner, response in
                    switch response {
                    case .success(let success):
                        //dump(success.data)
                        var updatedPosts = postsRelay.value
                        updatedPosts.append(contentsOf: success.data)
                        postsRelay.accept(updatedPosts)
                        nextCursor.accept(success.next_cursor)
                    case .failure(let failure):
                        fetchFailureRelay.accept(failure)
                    }
                    isLoadingSpinnerAvaliable.accept(false)
                }
                .disposed(by: disposeBag)
        }

        
//        input.fetchMoreDatas
//            .compactMap { $0.last?.row }
//            .bind(with: self, onNext: { owner, index in
//                print(index)
//                print("==인덱스==", index, postsRelay.value.count)
//                guard index == 0 else { return }
//                print("==인덱스!!!==", index, postsRelay.value.count)
//                input.loadTrigger.accept(())
//            })
//            .disposed(by: disposeBag)
        
        return Output(posts: postsRelay.asDriver(), fetchFailure: fetchFailureRelay)
    }
}
