//
//  SearchViewModel.swift
//  DogRun
//
//  Created by 이재희 on 5/4/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    var disposeBag: RxSwift.DisposeBag = .init()
    
    let searchResults = BehaviorRelay<[PostResponse]>(value: [])
    
    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let modelSelected: ControlEvent<PostResponse>
        let fetchMoreDatas: Observable<Int>
    }
    
    struct Output {
        let searchButtonTap: Driver<Void>
        let searchResults: BehaviorRelay<[PostResponse]>
        let modelSelected: Driver<PostResponse>
        let searchFailure: PublishRelay<DRError>
    }
    
    func transform(input: Input) -> Output {
        let searchFailure = PublishRelay<DRError>()
        let nextCursor = BehaviorRelay<String?>(value: nil)
        let lastSearchText = BehaviorRelay(value: "")
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .withUnretained(self)
            .flatMapLatest { owner, value in
                lastSearchText.accept(value)
                return NetworkManager.request2(type: PostsResponse.self, router: PostRouter.searchHashTag(query: .init(next: nil, limit: "15", product_id: "dr_sns", hashTag: value)))
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    owner.searchResults.accept(success.data)
                    nextCursor.accept(success.next_cursor)
                case .failure(let failure):
                    searchFailure.accept(failure)
                }
            }
            .disposed(by: disposeBag)
        
        input.fetchMoreDatas
            .withUnretained(self)
            .filter { owner, index in
                nextCursor.value != "0" && index == owner.searchResults.value.count-1
            }
            .flatMapLatest { owner, value in
                return NetworkManager.request2(type: PostsResponse.self, router: PostRouter.searchHashTag(query: .init(next: nextCursor.value, limit: "15", product_id: nil, hashTag: lastSearchText.value)))
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    var updatedPosts = owner.searchResults.value
                    updatedPosts.append(contentsOf: success.data)
                    owner.searchResults.accept(updatedPosts)
                    nextCursor.accept(success.next_cursor)
                case .failure(let failure):
                    searchFailure.accept(failure)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            searchButtonTap: input.searchButtonTap.asDriver(),
            searchResults: searchResults,
            modelSelected: input.modelSelected.asDriver(),
            searchFailure: searchFailure)
    }
}
