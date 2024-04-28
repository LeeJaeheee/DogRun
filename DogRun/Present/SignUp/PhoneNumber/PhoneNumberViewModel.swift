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
    }
    
    struct Output {
        let isPhoneNumberValid: Driver<Bool>
        let phoneNumber: Driver<String>
        let nextButtonTap: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let maxDigitsLength = 13
        
        let phoneNumber = input.phoneNumber
            .orEmpty
            .map { $0.formattedPhoneNumber() }
            .share()
        
        let isPhoneNumberValid = phoneNumber
            .map { $0.count == maxDigitsLength }
            .asDriver(onErrorJustReturn: false)
        
        return Output(
            isPhoneNumberValid: isPhoneNumberValid,
            phoneNumber: phoneNumber
                .asDriver(onErrorJustReturn: ""),
            nextButtonTap: input.nextButtonTap.asDriver()
        )
        
    }
    
}


