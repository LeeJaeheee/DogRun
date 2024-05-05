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
        case like
        case specific
        case all
    }
    
    var disposeBag = DisposeBag()
    
    var usertype = UserType.all
    var userId = UserDefaultsManager.userId
    
    let postsRelay = BehaviorRelay<[PostResponse]>(value: [])
    
    struct Input {
        let loadTrigger: BehaviorRelay<Void>
        let fetchMoreDatas: ControlEvent<WillDisplayCellEvent>
        let refreshTrigger: ControlEvent<Void>
    }
    
    struct Output {
        let posts: Driver<[PostResponse]>
        let fetchFailure: PublishRelay<DRError>
//        let refreshControlAction: PublishSubject<Void>
//        let refreshControlCompelted: PublishSubject<Void>
        let isLoadingSpinnerAvaliable: PublishRelay<Bool>
    }
    
    func transform(input: Input) -> Output {
        
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
                        var updatedPosts = owner.postsRelay.value
                        updatedPosts.append(contentsOf: success.data)
                        owner.postsRelay.accept(updatedPosts)
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
                        var updatedPosts = owner.postsRelay.value
                        updatedPosts.append(contentsOf: success.data)
                        owner.postsRelay.accept(updatedPosts)
                        nextCursor.accept(success.next_cursor)
                    case .failure(let failure):
                        fetchFailureRelay.accept(failure)
                    }
                    isLoadingSpinnerAvaliable.accept(false)
                }
                .disposed(by: disposeBag)
        case .like:
            input.loadTrigger
                .flatMapLatest { _ in
                    isLoadingSpinnerAvaliable.accept(true)
                    return NetworkManager.request2(type: PostsResponse.self, router: LikeRouter.fetchLike(query: .init(next: nextCursor.value, limit: nil)))
                }
                .bind(with: self) { owner, response in
                    switch response {
                    case .success(let success):
                        //dump(success.data)
                        var updatedPosts = owner.postsRelay.value
                        updatedPosts.append(contentsOf: success.data)
                        owner.postsRelay.accept(updatedPosts)
                        nextCursor.accept(success.next_cursor)
                    case .failure(let failure):
                        fetchFailureRelay.accept(failure)
                    }
                    isLoadingSpinnerAvaliable.accept(false)
                }
                .disposed(by: disposeBag)
        }
        
        input.refreshTrigger
            .bind(with: self) { owner, _ in
                owner.postsRelay.accept([])
                nextCursor.accept(nil)
                input.loadTrigger.accept(())
            }
            .disposed(by: disposeBag)

        
        input.fetchMoreDatas
            .compactMap { $0.indexPath }
            .bind(with: self, onNext: { owner, index in
                guard nextCursor.value != "0", index.row == owner.postsRelay.value.count-2 else { return }
                input.loadTrigger.accept(())
            })
            .disposed(by: disposeBag)
        
        return Output(
            posts: postsRelay.asDriver(),
            fetchFailure: fetchFailureRelay,
            isLoadingSpinnerAvaliable: isLoadingSpinnerAvaliable
        )
    }
    

}

extension UserFeedViewModel {
    func tapLikeButton(post: PostResponse, index: Int) {
        let likeStatus = !post.likes.contains(UserDefaultsManager.userId)
        likePost(postId: post.post_id, likeStatus: likeStatus)
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let success):
                    var updatedPosts = owner.postsRelay.value
                    updatedPosts[index] = owner.duplicate(post: post, likeStatus: success.like_status)
                    owner.postsRelay.accept(updatedPosts)
                case .failure(let failure):
                    print(failure)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func likePost(postId: String, likeStatus: Bool) -> Single<Result<LikeModel, DRError>> {
        return NetworkManager.request2(type: LikeModel.self, router: LikeRouter.like(postId: postId, model: .init(like_status: likeStatus)))
    }
    
    private func duplicate(post: PostResponse, likeStatus: Bool) -> PostResponse {
        var newlikes = post.likes
        if likeStatus {
            newlikes.append(UserDefaultsManager.userId)
        } else {
            newlikes.removeAll { $0 == UserDefaultsManager.userId }
        }
        
        return PostResponse(
            post_id: post.post_id,
            product_id: post.product_id,
            title: post.title,
            content: post.content,
            content1: post.content1,
            content2: post.content2,
            content3: post.content3,
            content4: post.content4,
            content5: post.content5,
            createdAt: post.createdAt,
            creator: post.creator,
            files: post.files,
            likes: newlikes,
            likes2: post.likes2,
            hashTags: post.hashTags,
            comments: post.comments)
    }
}
