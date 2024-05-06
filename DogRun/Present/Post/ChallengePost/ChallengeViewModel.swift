//
//  ChallengeViewModel.swift
//  DogRun
//
//  Created by 이재희 on 5/6/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChallengeViewModel: ViewModelType {
    var disposeBag: RxSwift.DisposeBag = .init()
    
    let registerIndex = BehaviorRelay(value: 0)
    let paymentsRelay = PublishRelay<PaymentsModel>()
    
    struct Input {
        let loadBannerTrigger: BehaviorRelay<Void>
        let loadChallengeTrigger: BehaviorRelay<Void>
    }
    
    struct Output {
        let bannerList: Driver<[BannerResponse]>
        let recommendList: Driver<[ChallengeResponse]>
        let postList: Driver<[ChallengeResponse]>
        let requestFailure: PublishRelay<DRError>
        let paymentSuccess: PublishRelay<PaymentResponse>
        let paymentFailure: PublishRelay<Void>
    }
    
    func transform(input: Input) -> Output {
        let requestFailure = PublishRelay<DRError>()
        
        let paymentSuccess = PublishRelay<PaymentResponse>()
        let paymentFailure = PublishRelay<Void>()
        
        let bannerList = BehaviorRelay<[BannerResponse]>(value: [])
        let recommendList = BehaviorRelay<[ChallengeResponse]>(value: [])
        let postList = BehaviorRelay<[ChallengeResponse]>(value: [])
        
        let postNextCursor = BehaviorRelay<String?>(value: nil)
        
        
        
        input.loadBannerTrigger
            .flatMap { _ in
                NetworkManager.request2(type: BannersResponse.self, router: PostRouter.fetchPost(query: .init(next: nil, limit: "15", product_id: "dr_banner", hashTag: nil)))
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    bannerList.accept(success.data)
                case .failure(let failure):
                    requestFailure.accept(failure)
                }
            }
            .disposed(by: disposeBag)
        
        let challengeObservable = input.loadChallengeTrigger
            .flatMap { _ in
                NetworkManager.request2(type: ChallengesResponse.self, router: PostRouter.fetchPost(query: .init(next: postNextCursor.value, limit: "15", product_id: "dr_challenge", hashTag: nil)))
            }
            .share()
        
        challengeObservable
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    postList.accept(success.data)
                    postNextCursor.accept(success.next_cursor)
                case .failure(let failure):
                    requestFailure.accept(failure)
                }
            }
            .disposed(by: disposeBag)
        
        challengeObservable
            .take(1)
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    recommendList.accept(Array(success.data.shuffled().prefix(5)))
                case .failure(_):
                    print("")
                }
            }
            .disposed(by: disposeBag)
        
        paymentsRelay
            .flatMap { payments in
                return NetworkManager.request2(type: PaymentResponse.self, router: PaymentsRouter.validation(model: payments))
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    paymentSuccess.accept(success)
                case .failure(let failure):
                    requestFailure.accept(failure)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            bannerList: bannerList.asDriver(onErrorJustReturn: []),
            recommendList: recommendList.asDriver(onErrorJustReturn: []),
            postList: postList.asDriver(onErrorJustReturn: []), 
            requestFailure: requestFailure,
            paymentSuccess: paymentSuccess,
            paymentFailure: paymentFailure
        )
    }
    
}
