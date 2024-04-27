//
//  WelcomeViewModel.swift
//  DogRun
//
//  Created by 이재희 on 4/27/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WelcomeViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let signUpButtonTap: ControlEvent<Void>
        let signInButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let navigateToSignUp: Driver<Void>
        let navigateToSignIn: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        return Output(
            navigateToSignUp: input.signUpButtonTap.asDriver(),
            navigateToSignIn: input.signInButtonTap.asDriver()
        )
    }
    
}
