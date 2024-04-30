//
//  PasswordView.swift
//  DogRun
//
//  Created by 이재희 on 4/21/24.
//

import UIKit
import SnapKit

final class PasswordView: ModeBaseView {
    
    let titleLabel = DRLabel(text: "비밀번호를\n입력해주세요.", style: .title)
    let passwordTextField = DRTextField(title: "비밀번호")
    let firstValidationView = ValidationView(text: "문자길이 최소 8자리 이상 20자리 이하", image: .checkmark)
    let secondValidationView = ValidationView(text: "영문+숫자 조합 포함", image: .checkmark)
    lazy var nextButton = DRButton(title: mode == .basic ? "다음" : "로그인")
    
    override func configureHierarchy() {
        [titleLabel, passwordTextField, firstValidationView, secondValidationView, nextButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(passwordTextField.basicHeight)
        }
        
        firstValidationView.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(passwordTextField).inset(16)
            make.height.equalTo(24)
        }
        
        secondValidationView.snp.makeConstraints { make in
            make.top.equalTo(firstValidationView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(passwordTextField).inset(16)
            make.height.equalTo(24)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(nextButton.basicHorizontalInset)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(nextButton.basicBottomInset)
            // FIXME: 아래 코드로 실행하면 textfieldeffects에서 문제생김 (animateViewsForTextEntry() 호출안함)
            //make.bottom.equalTo(keyboardLayoutGuide.snp.top).inset(-16)
            make.height.equalTo(nextButton.basicHeight)
        }
    }
    
    override func configureView() {
        nextButton.isEnabled = false
        passwordTextField.isSecureTextEntry = true
    }
    
    override func configureMode() {
        switch mode {
        case .basic:
            break
        case .modify:
            firstValidationView.isHidden = true
            secondValidationView.isHidden = true
        }
    }
    
}
