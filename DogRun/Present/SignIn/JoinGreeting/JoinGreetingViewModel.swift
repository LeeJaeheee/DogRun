//
//  JoinGreetingViewModel.swift
//  DogRun
//
//  Created by 이재희 on 4/30/24.
//

import Foundation
import RxSwift
import RxCocoa

final class JoinGreetingViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    var loginRequest = LoginRequest(email: "", password: "")
    
    struct Input {
        let nextButtonTap: ControlEvent<Void>
    }

    struct Output {
        let signInSuccess: PublishRelay<Void>
        let signInFailure: PublishRelay<DRError>
    }

    func transform(input: Input) -> Output {

        let signInSuccess = PublishRelay<Void>()
        let signInFailure = PublishRelay<DRError>()
        
        input.nextButtonTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { _ in
                NetworkManager.request2(type: LoginResponse.self, router: UserRouter.login(model: self.loginRequest))
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    dump(success)
                    UserDefaultsManager.accessToken = success.accessToken
                    UserDefaultsManager.refreshToken = success.refreshToken
                    signInSuccess.accept(())
                case .failure(let failure):
                    print(failure)
                    signInFailure.accept(failure)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            signInSuccess: signInSuccess,
            signInFailure: signInFailure
        )
    }

}
