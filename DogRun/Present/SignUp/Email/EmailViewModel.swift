//
//  EmailViewModel.swift
//  DogRun
//
//  Created by 이재희 on 4/21/24.
//

import Foundation
import RxSwift
import RxCocoa

final class EmailViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let email: ControlProperty<String?>
        let validButtonTap: ControlEvent<Void>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let isEmailValid: Driver<Bool>
        let isNextButtonEnabled: Driver<Bool>
        let emailValidResult: PublishRelay<String>
        let navigateToNextVC: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let isNextButtonEnabled = PublishRelay<Bool>()
        let emailValidResult = PublishRelay<String>()

        let isEmailValid = input.email.orEmpty
            .map { self.isEmailValid($0) }
            .asDriver(onErrorJustReturn: false)

        let emailChanged = input.email
            .distinctUntilChanged()
            .map { _ in false }

        let emailValidation = input.validButtonTap
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(input.email.orEmpty)
            .flatMapLatest { email in
                NetworkManager.request2(type: EmailValidationResponse.self, router: ValidationRouter.email(model: .init(email: email)))
            }
            .map { response -> Bool in
                switch response {
                case .success(let success):
                    emailValidResult.accept(success.message)
                    return true
                case .failure(let failure):
                    emailValidResult.accept(failure.localizedDescription)
                    return false
                }
            }

        Observable.merge(emailChanged, emailValidation)
            .bind(to: isNextButtonEnabled)
            .disposed(by: disposeBag)

        return Output(
            isEmailValid: isEmailValid,
            isNextButtonEnabled: isNextButtonEnabled.asDriver(onErrorJustReturn: false),
            emailValidResult: emailValidResult, 
            navigateToNextVC: input.nextButtonTap.asDriver()
        )
    }
    
    func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
