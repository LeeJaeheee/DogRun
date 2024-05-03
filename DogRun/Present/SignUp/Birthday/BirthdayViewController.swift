//
//  BirthdayViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/28/24.
//

import UIKit
import RxSwift
import RxCocoa

final class BirthdayViewController: ModeBaseViewController<BirthdayView> {
    let viewModel = BirthdayViewModel()
    
    let barbuttonItem = UIBarButtonItem(systemItem: .done)
    
    var popAction: ((ProfileResponse) -> Void)?
    
    override func configureNavigation() {
        if mainView.mode == .modify {
            navigationItem.rightBarButtonItem = barbuttonItem
        }
    }
    
    override func configureView() {
        if mainView.mode == .modify {
            mainView.nextButton.isHidden = true
            mainView.birthdayTextField.text = viewModel.phoneNumber
        }
    }
    
    override func bind() {
        let input = BirthdayViewModel.Input(
            birthday: mainView.birthdayTextField.rx.text,
            dateChanged: mainView.datePicker.rx.date,
            doneButtonTap: mainView.doneButton.rx.tap,
            nextButtonTap: mainView.nextButton.rx.tap,
            barDoneButtonTap: barbuttonItem.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.formattedDate
            .drive(mainView.birthdayTextField.rx.text)
            .disposed(by: disposeBag)

        output.isNextButtonEnabled
            .drive(mainView.birthdayTextField.rx.isValid, mainView.nextButton.rx.isEnabled, barbuttonItem.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.doneButtonTap
            .drive(with: self) { owner, _ in
                owner.mainView.birthdayTextField.text = DateFormatterManager.shared.string(from: owner.mainView.datePicker.date)
                owner.mainView.birthdayTextField.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        
        output.nextButtonTap
            .drive(with: self) { owner, _ in
                //let nextVC = PasswordViewController()
                //owner.navigationController?.pushViewController(nextVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.signUpSuccess
            .bind(with: self) { owner, loginRequest in
                let vc = JoinGreetingViewController()
                vc.viewModel.loginRequest = loginRequest
                owner.changeRootView(to: vc)
            }
            .disposed(by: disposeBag)
        
        output.signUpFailure
            .bind(with: self) { owner, error in
                owner.errorHandler(error)
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
