//
//  NicknameViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/21/24.
//

import UIKit
import SnapKit

final class NicknameViewController: ModeBaseViewController<NicknameView> {
    
    let viewModel = NicknameViewModel()
    
    let barbuttonItem = UIBarButtonItem(systemItem: .done)
    
    var email: String = ""
    var password: String = ""
    var nickname: String = ""
    
    var popAction: ((ProfileResponse) -> Void)?
    
    override func configureNavigation() {
        if mainView.mode == .modify {
            navigationItem.rightBarButtonItem = barbuttonItem
        }
    }
    
    override func configureView() {
        if mainView.mode == .modify {
            mainView.nextButton.isHidden = true
            mainView.nicknameTextField.text = nickname
        }
    }
    
    override func bind() {
        let input = NicknameViewModel.Input(
            nickname: mainView.nicknameTextField.rx.text,
            nextButtonTap: mainView.nextButton.rx.tap,
            barDoneButtonTap: barbuttonItem.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.isNicknameValid
            .drive(mainView.nicknameTextField.rx.isValid, mainView.nextButton.rx.isEnabled, barbuttonItem.rx.isEnabled)
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
                nextVC.email = owner.email
                nextVC.password = owner.password
                nextVC.nickname = owner.mainView.nicknameTextField.text ?? ""
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
