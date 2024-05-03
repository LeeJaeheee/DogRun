//
//  PhoneNumberViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/28/24.
//

import UIKit
import SnapKit

final class PhoneNumberViewController: ModeBaseViewController<PhoneNumberView> {
    
    let viewModel = PhoneNumberViewModel()
    
    let barbuttonItem = UIBarButtonItem(systemItem: .done)
    
    var email: String = ""
    var password: String = ""
    var nickname: String = ""
    var phoneNumber: String = ""
    
    var popAction: ((ProfileResponse) -> Void)?
    
    override func configureNavigation() {
        if mainView.mode == .modify {
            navigationItem.rightBarButtonItem = barbuttonItem
        }
    }
    
    override func configureView() {
        if mainView.mode == .modify {
            mainView.nextButton.isHidden = true
            mainView.phoneNumberTextField.text = phoneNumber
        }
    }
    
    override func bind() {
        let input = PhoneNumberViewModel.Input(
            phoneNumber: mainView.phoneNumberTextField.rx.text,
            nextButtonTap: mainView.nextButton.rx.tap,
            barDoneButtonTap: barbuttonItem.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.isPhoneNumberValid
            .drive(mainView.phoneNumberTextField.rx.isValid, mainView.nextButton.rx.isEnabled, barbuttonItem.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.phoneNumber
            .drive(mainView.phoneNumberTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.nextButtonTap
            .drive(with: self) { owner, _ in
                let nextVC = BirthdayViewController()
                nextVC.viewModel.email = owner.email
                nextVC.viewModel.password = owner.password
                nextVC.viewModel.nickname = owner.nickname
                nextVC.viewModel.phoneNumber = owner.mainView.phoneNumberTextField.text ?? ""
                owner.navigationController?.pushViewController(nextVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.updateSuccess
            .bind(with: self) { owner, updatedProfile in
                owner.popAction?(updatedProfile)
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.updateFailure
            .bind(with: self) { owner, error in
                owner.errorHandler(error)
            }
            .disposed(by: disposeBag)
    }

}
