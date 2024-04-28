//
//  BirthdayViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthdayViewController: BaseViewController<BirthdayView> {
    let viewModel = BirthdayViewModel()
    
    override func bind() {
        let input = BirthdayViewModel.Input(
            birthday: mainView.birthdayTextField.rx.text,
            dateChanged: mainView.datePicker.rx.date,
            doneButtonTap: mainView.doneButton.rx.tap,
            nextButtonTap: mainView.nextButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)

        output.formattedDate
            .drive(mainView.birthdayTextField.rx.text)
            .disposed(by: disposeBag)

        output.isNextButtonEnabled
            .drive(mainView.birthdayTextField.rx.isValid, mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.doneButtonTap
            .drive(with: self) { owner, _ in
                owner.mainView.birthdayTextField.text = DateFormatterManager.shared.string(from: owner.mainView.datePicker.date)
                owner.mainView.birthdayTextField.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        
        output.nextButtonTap
            .drive(with: self) { owner, _ in
                let nextVC = PasswordViewController()
                owner.navigationController?.pushViewController(nextVC, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
}
