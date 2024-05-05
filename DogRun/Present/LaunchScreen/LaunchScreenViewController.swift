//
//  LaunchScreenViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/27/24.
//

import UIKit
import RxSwift
import RxCocoa

// TODO: LaunchScreen이랑 연결시켜서 여기서 온보딩/로그인 여부 판단하기
final class LaunchScreenViewController: BaseViewController<LaunchScreenView> {
    
    let viewModel = LaunchScreenViewModel()
    
    override func bind() {
        
        let input = LaunchScreenViewModel.Input(checkLoginStatus: Observable.just(()))
        let output = viewModel.transform(input: input)
        
        output.isValidUser
            .drive(with: self) { owner, isValid in
                sleep(2)
                if isValid {
                    owner.changeRootView(to: MainTabbarController())
                } else {
                    print("왜안되지?")
                    owner.changeRootView(to: WelcomeViewController(), isNav: true)
                }
            }
            .disposed(by: disposeBag)

    }
}
