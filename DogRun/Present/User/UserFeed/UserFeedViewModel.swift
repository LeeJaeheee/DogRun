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
    var disposeBag = DisposeBag()
    private var nextCursor: String?
    
    struct Input {
        let loadTrigger: Observable<Void>
    }
    
    struct Output {
        let posts: Driver<[PostResponse]>
        let fetchFailure: PublishRelay<DRError>
    }
    
    func transform(input: Input) -> Output {
        let postsRelay = BehaviorRelay<[PostResponse]>(value: [])
        let fetchFailureRelay = PublishRelay<DRError>()
        
        input.loadTrigger
            .flatMap { _ in
                return NetworkManager.request2(type: PostsResponse.self, router: PostRouter.fetchPost(query: .init(next: nil, limit: nil, product_id: nil, hashTag: nil)))
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    postsRelay.accept(success.data)
                    owner.nextCursor = success.next_cursor
                case .failure(let failure):
                    fetchFailureRelay.accept(failure)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(posts: postsRelay.asDriver(), fetchFailure: fetchFailureRelay)
    }
}
