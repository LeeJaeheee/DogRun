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
    
    override func bind() {
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
                    owner.navigationController?.pushViewController(nextVC, animated: true)
                }
                .disposed(by: disposeBag)
            
        case .modify:
            output.isNotEmpty
                .drive(mainView.nextButton.rx.isEnabled, mainView.passwordTextField.rx.isValid)
                .disposed(by: disposeBag)
            
            // TODO: 네트워크 연결
            output.nextButtonTap
                .drive(with: self) { owner, _ in
                    let nextVC = NicknameViewController()
                    owner.navigationController?.pushViewController(nextVC, animated: true)
                }
                .disposed(by: disposeBag)
        }
        
    }

}
