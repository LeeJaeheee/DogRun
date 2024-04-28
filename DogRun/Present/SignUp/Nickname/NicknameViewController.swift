//
//  NicknameViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/21/24.
//

import UIKit
import SnapKit

final class NicknameViewController: BaseViewController<NicknameView> {
    
    let viewModel = NicknameViewModel()
    
    override func bind() {
        let input = NicknameViewModel.Input(
            nickname: mainView.nicknameTextField.rx.text,
            nextButtonTap: mainView.nextButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.isNicknameValid
            .drive(mainView.nicknameTextField.rx.isValid, mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.nicknameCountLabel
            .drive(mainView.countLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.nickname
            .drive(mainView.nicknameTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.nextButtonTap
            .drive(with: self) { owner, _ in
                let nextVC = PhoneNumberViewController()
                owner.navigationController?.pushViewController(nextVC, animated: true)
            }
            .disposed(by: disposeBag)
    }

}
