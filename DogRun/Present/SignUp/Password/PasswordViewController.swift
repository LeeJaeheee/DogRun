//
//  PasswordViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/21/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PasswordViewController: ModeBaseViewController<PasswordView> {
    
    let viewModel = PasswordViewModel()
    
    var email: String = ""
    
    override func bind() {
        viewModel.email = email
        viewModel.isModify = mainView.mode == .modify
        
        let input = PasswordViewModel.Input(
            password: mainView.passwordTextField.rx.text,
            nextButtonTap: mainView.nextButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        switch mainView.mode {
        case .basic:
            output.lengthValidation
                .drive(mainView.firstValidationView.rx.isValid)
                .disposed(by: disposeBag)
            
            output.alphanumericValidation
                .drive(mainView.secondValidationView.rx.isValid)
                .disposed(by: disposeBag)
            
            output.isPasswordValid
                .drive(mainView.nextButton.rx.isEnabled, mainView.passwordTextField.rx.isValid)
                .disposed(by: disposeBag)
            
            output.nextButtonTap
                .drive(with: self) { owner, _ in
                    let nextVC = NicknameViewController()
                    nextVC.email = owner.email
                    nextVC.password = owner.mainView.passwordTextField.text ?? ""
                    owner.navigationController?.pushViewController(nextVC, animated: true)
                }
                .disposed(by: disposeBag)
            
        case .modify:
            output.isNotEmpty
                .drive(mainView.nextButton.rx.isEnabled, mainView.passwordTextField.rx.isValid)
                .disposed(by: disposeBag)
            
            output.signInSuccess
                .bind(with: self) { owner, _ in
                    // present한거면 dismiss하고 런치스크린에서 들어온거면 changeVC로 변경해주기
                    // TODO: present한 경우 dismiss하고나서 실패한 호출 다시 진행? 피드는 다시 로드해와야됨
                    if owner.presentingViewController != nil {
                        owner.dismiss(animated: true)
                    } else {
                        owner.changeRootView(to: MainTabbarController())
                    }
                }
                .disposed(by: disposeBag)
            
            output.signInFailure
                .bind(with: self) { owner, error in
                    if error.handlingRule == .showLogin {
                        owner.showToast(error.errorMessage, position: .center)
                    } else {
                        owner.errorHandler(error)
                    }
                }
                .disposed(by: disposeBag)
        }
        
    }

}
