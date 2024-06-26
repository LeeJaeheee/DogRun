//
//  UserGalleryViewModel.swift
//  DogRun
//
//  Created by 이재희 on 5/3/24.
//

import Foundation
import RxSwift
import RxCocoa

final class UserGalleryViewModel: ViewModelType {
    var disposeBag: RxSwift.DisposeBag = .init()
    
    var userId = UserDefaultsManager.userId
    
    struct Input {
        let loadTrigger: BehaviorRelay<Void>
        let fetchMoreDatas: Observable<Int>
        let refreshTrigger: ControlEvent<Void>
    }
    
    struct Output {
        let posts: Driver<[PostResponse]>
        let fetchFailure: PublishRelay<DRError>
        let files: Driver<[String]>
        //let endRefresh: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let postsRelay = BehaviorRelay<[PostResponse]>(value: [])
        let nextCursor = BehaviorRelay<String?>(value: nil)
        let fetchFailureRelay = PublishRelay<DRError>()
        
        let filesRelay = BehaviorRelay<[String]>(value: [])
        
        input.loadTrigger
            .flatMapLatest { _ in
                return NetworkManager.request2(type: PostsResponse.self, router: PostRouter.fetchUserPost(id: self.userId, query: .init(next: nextCursor.value, limit: "10", product_id: nil, hashTag: nil)))
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
            }
            .disposed(by: disposeBag)
        
        postsRelay
            .map { $0.compactMap { $0.files} }
            .bind(with: self) { owner, fileList in
                filesRelay.accept(fileList.flatMap { $0 })
                print("!!!@!@!@")
                print(fileList.flatMap { $0 })
            }
            .disposed(by: disposeBag)
        
        input.refreshTrigger
            .bind(onNext: { _ in
                postsRelay.accept([])
                nextCursor.accept(nil)
                input.loadTrigger.accept(())
            })
            .disposed(by: disposeBag)
        
        input.fetchMoreDatas
            .bind(with: self) { owner, index in
                guard nextCursor.value != "0", index == filesRelay.value.count-2 else { return }
                input.loadTrigger.accept(())
            }
            .disposed(by: disposeBag)
            
        
        return Output(posts: postsRelay.asDriver(),
                      fetchFailure: fetchFailureRelay,
                      files: filesRelay.asDriver())
    }
    
}
