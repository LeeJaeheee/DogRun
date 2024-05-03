//
//  PhoneNumberViewModel.swift
//  DogRun
//
//  Created by 이재희 on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PhoneNumberViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let phoneNumber: ControlProperty<String?>
        let nextButtonTap: ControlEvent<Void>
        let barDoneButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let isPhoneNumberValid: Driver<Bool>
        let phoneNumber: Driver<String>
        let nextButtonTap: Driver<Void>
        let updateSuccess: PublishRelay<ProfileResponse>
        let updateFailure: PublishRelay<DRError>
    }
    
    func transform(input: Input) -> Output {
        let maxDigitsLength = 13
        
        let updateSuccess = PublishRelay<ProfileResponse>()
        let updateFailure = PublishRelay<DRError>()
        
        let phoneNumber = input.phoneNumber
            .orEmpty
            .map { $0.formattedPhoneNumber() }
            .share()
        
        let isPhoneNumberValid = phoneNumber
            .map { $0.count == maxDigitsLength }
            .asDriver(onErrorJustReturn: false)
        
        input.barDoneButtonTap
            .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .withLatestFrom(phoneNumber)
            .flatMap { value in
                return NetworkManager.requestMultipart(type: ProfileResponse.self, router: UserRouter.editMyProfile(model: .init(nick: nil, phoneNum: value, birthDay: nil, profile: nil)))
            }
            .bind(with: self) { owner, value in
                switch value {
                case .success(let success):
                    updateSuccess.accept((success))
                case .failure(let failure):
                    updateFailure.accept(failure)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            isPhoneNumberValid: isPhoneNumberValid,
            phoneNumber: phoneNumber
                .asDriver(onErrorJustReturn: ""),
            nextButtonTap: input.nextButtonTap.asDriver(),
            updateSuccess: updateSuccess,
            updateFailure: updateFailure
        )
        
    }
    
}


