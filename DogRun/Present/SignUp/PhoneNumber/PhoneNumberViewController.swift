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
    
    override func bind() {
        let input = PhoneNumberViewModel.Input(
            phoneNumber: mainView.phoneNumberTextField.rx.text,
            nextButtonTap: mainView.nextButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.isPhoneNumberValid
            .drive(mainView.phoneNumberTextField.rx.isValid, mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.phoneNumber
            .drive(mainView.phoneNumberTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.nextButtonTap
            .drive(with: self) { owner, _ in
                let nextVC = BirthdayViewController()
                owner.navigationController?.pushViewController(nextVC, animated: true)
            }
            .disposed(by: disposeBag)
    }

}
