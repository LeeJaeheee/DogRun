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
        let isValidUser = input.checkLoginStatus
            .map {
                UserDefaults.standard.value(forKey: "accessToken") != nil
            }
            .asDriver(onErrorJustReturn: false)
        
        return Output(isValidUser: isValidUser)
    }
}
