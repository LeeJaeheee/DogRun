//
//  UserChallengeViewModel.swift
//  DogRun
//
//  Created by 이재희 on 5/7/24.
//

import Foundation
import RxSwift
import RxCocoa

final class UserChallengeViewModel: ViewModelType {
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        let loadTrigger: BehaviorRelay<Void>
    }
    
    struct Output {
        let paymentsList: BehaviorRelay<[PaymentResponse]>
        let challengeList: BehaviorRelay<[ChallengeResponse]>
        let fetchFailure: PublishRelay<DRError>
    }
    
    func transform(input: Input) -> Output {
        let paymentsList = BehaviorRelay<[PaymentResponse]>(value: [])
        let challengeList = BehaviorRelay<[ChallengeResponse]>(value: [])
        let fetchFailure = PublishRelay<DRError>()
        
        input.loadTrigger
            .flatMap { _ in
                return NetworkManager.request2(type: PaymentsResponse.self, router: PaymentsRouter.myPayments)
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    paymentsList.accept(success.data)
                case .failure(let failure):
                    fetchFailure.accept(failure)
                }
            }
            .disposed(by: disposeBag)
        
        // TODO: 이미지 받아오기

        return Output(
            paymentsList: paymentsList,
            challengeList: challengeList,
            fetchFailure: fetchFailure)
    }
    
}
