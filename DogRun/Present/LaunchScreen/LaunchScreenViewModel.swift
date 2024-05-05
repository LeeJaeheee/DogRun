//
//  LaunchScreenViewModel.swift
//  DogRun
//
//  Created by 이재희 on 4/27/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LaunchScreenViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let checkLoginStatus: Observable<Void>
    }
    
    struct Output {
        let isValidUser: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let isValidUser = PublishRelay<Bool>()
        
        input.checkLoginStatus
            .flatMap { _ in
                return NetworkManager.requestTokenRefresh(type: AuthResponse.self, router: AuthRouter.refresh)
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    UserDefaultsManager.accessToken = success.accessToken
                    isValidUser.accept(true)
                case .failure(let failure):
                    print(failure)
                    isValidUser.accept(false)
                    print(isValidUser)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            isValidUser: isValidUser.asDriver(onErrorJustReturn: false))
    }
}
