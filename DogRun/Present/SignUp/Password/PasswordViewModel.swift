//
//  PasswordViewModel.swift
//  DogRun
//
//  Created by 이재희 on 4/21/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PasswordViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let password: ControlProperty<String?>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let lengthValidation: Driver<Bool>
        let alphanumericValidation: Driver<Bool>
        let isPasswordValid: Driver<Bool>
        let nextButtonTap: Driver<Void>
        let isNotEmpty: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let password = input.password.orEmpty.share()
        
        let lengthRule = password
            .map { $0.count >= 8 && $0.count <= 20 }
            .asDriver(onErrorJustReturn: false)
        
        let alphanumericRule = password
            .map { password in
                let pattern = "^(?=.*[0-9])(?=.*[a-zA-Z]).*$"
                return password.range(of: pattern, options: .regularExpression) != nil
            }
            .asDriver(onErrorJustReturn: false)
        
        let isPasswordValid = Driver.combineLatest(lengthRule, alphanumericRule) { $0 && $1 }
        
        let isNotEmpty = password
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        return Output(lengthValidation: lengthRule,
                       alphanumericValidation: alphanumericRule,
                      isPasswordValid: isPasswordValid,
                      nextButtonTap: input.nextButtonTap.asDriver(),
                      isNotEmpty: isNotEmpty)
    }
    
}
