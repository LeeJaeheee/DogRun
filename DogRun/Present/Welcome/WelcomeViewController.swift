//
//  WelcomeViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/27/24.
//

import UIKit
import RxSwift
import RxCocoa

final class WelcomeViewController: BaseViewController<WelcomeView> {
    
    let viewModel = WelcomeViewModel()
    
    override func bind() {
        let output = viewModel.transform(input: .init(
            signUpButtonTap: mainView.signUpButton.rx.tap,
            signInButtonTap: mainView.signInButton.rx.tap))
        
        output.navigateToSignUp
            .drive(with: self) { owner, _ in
                let signUpVC = PhoneNumberViewController()
                owner.navigationController?.pushViewController(signUpVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.navigateToSignIn
            .drive(with: self) { owner, _ in
                let signInVC = EmailViewController(mode: .modify)
                owner.navigationController?.pushViewController(signInVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}
