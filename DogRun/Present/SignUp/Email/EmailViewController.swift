//
//  EmailViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/21/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class EmailViewController: ModeBaseViewController<EmailView> {
    
    let viewModel = EmailViewModel()
    
    override func bind() {
        
        let input = EmailViewModel.Input(
            email: mainView.emailTextField.rx.text,
            validButtonTap: mainView.validButton.rx.tap,
            nextButtonTap: mainView.nextButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        switch mainView.mode {
        case .basic:
            output.isEmailValid
                .drive(mainView.validButton.rx.isEnabled, mainView.emailTextField.rx.isValid)
                .disposed(by: disposeBag)
        case .modify:
            output.isEmailValid
                .drive(mainView.nextButton.rx.isEnabled, mainView.emailTextField.rx.isValid)
                .disposed(by: disposeBag)
        }
        
        output.isNextButtonEnabled
            .drive(mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.emailValidResult
            .bind(with: self) { owner, value in
                owner.showToast(value, position: .top)
            }
            .disposed(by: disposeBag)
        
        output.navigateToNextVC
            .drive(with: self) { owner, _ in
                var nextVC: PasswordViewController
                switch owner.mainView.mode {
                case .basic:
                    nextVC = PasswordViewController()
                case .modify:
                    nextVC = PasswordViewController(mode: .modify)
                }
                nextVC.email = owner.mainView.emailTextField.text ?? ""
                owner.navigationController?.pushViewController(nextVC, animated: true)
            }
            .disposed(by: disposeBag)
    }

}
