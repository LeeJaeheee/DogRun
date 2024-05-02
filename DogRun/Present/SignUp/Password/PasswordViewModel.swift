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
    
    var email = ""
    var isModify = false
    
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
        let signInSuccess: PublishRelay<Void>
        let signInFailure: PublishRelay<DRError>
    }
    
    func transform(input: Input) -> Output {
        let signInSuccess = PublishRelay<Void>()
        let signInFailure = PublishRelay<DRError>()
        
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
        
        if isModify {
            input.nextButtonTap
                .debounce(.seconds(1), scheduler: MainScheduler.instance)
                .withLatestFrom(password)
                .flatMap { password in
                    NetworkManager.request2(type: LoginResponse.self, router: UserRouter.login(model: .init(email: self.email, password: password)))
                }
                .bind(with: self) { owner, response in
                    switch response {
                    case .success(let success):
                        dump(success)
                        UserDefaultsManager.accessToken = success.accessToken
                        UserDefaultsManager.refreshToken = success.refreshToken
                        UserDefaultsManager.userId = success.user_id
                        signInSuccess.accept(())
                    case .failure(let failure):
                        print(failure)
                        signInFailure.accept(failure)
                    }
                }
                .disposed(by: disposeBag)
        }
        
        return Output(lengthValidation: lengthRule,
                       alphanumericValidation: alphanumericRule,
                      isPasswordValid: isPasswordValid,
                      nextButtonTap: input.nextButtonTap.asDriver(),
                      isNotEmpty: isNotEmpty,
                      signInSuccess: signInSuccess,
                      signInFailure: signInFailure)
    }
    
}
