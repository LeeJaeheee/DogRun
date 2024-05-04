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
    }
    
    struct Output {
        let searchButtonTap: Driver<Void>
        let searchResults: BehaviorRelay<[PostResponse]>
        let modelSelected: ControlEvent<PostResponse>
        let searchFailure: PublishRelay<DRError>
    }
    
    func transform(input: Input) -> Output {
        let searchFailure = PublishRelay<DRError>()
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .withUnretained(self)
            .flatMapLatest { owner, value in
                return NetworkManager.request2(type: PostsResponse.self, router: PostRouter.searchHashTag(query: .init(next: nil, limit: "15", product_id: nil, hashTag: value)))
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    owner.searchResults.accept(success.data)
                case .failure(let failure):
                    searchFailure.accept(failure)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            searchButtonTap: input.searchButtonTap.asDriver(),
            searchResults: searchResults,
            modelSelected: input.modelSelected,
            searchFailure: searchFailure)
    }
}
