//
//  JoinGreetingViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/30/24.
//

import Foundation
import RxSwift
import RxCocoa

final class JoinGreetingViewController: BaseViewController<JoinGreetingView> {
    
    let viewModel = JoinGreetingViewModel()
    
    override func bind() {
        let input = JoinGreetingViewModel.Input(
            nextButtonTap: mainView.signInButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.signInSuccess
            .bind(with: self) { owner, _ in
                owner.changeRootView(to: MainTabbarController())
            }
            .disposed(by: disposeBag)
        
        output.signInFailure
            .bind(with: self) { owner, error in
                owner.changeRootView(to: EmailViewController(mode: .modify), isNav: true)
            }
            .disposed(by: disposeBag)
        
    }
}
