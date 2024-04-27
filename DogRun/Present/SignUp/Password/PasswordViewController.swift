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

final class PasswordViewController: BaseViewController<PasswordView> {
    
    let viewModel = PasswordViewModel()
    
    override func bind() {
        let input = PasswordViewModel.Input(
            password: mainView.passwordTextField.rx.text,
            nextButtonTap: mainView.nextButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
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
    }

}
