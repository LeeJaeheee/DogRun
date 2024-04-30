//
//  EmailView.swift
//  DogRun
//
//  Created by 이재희 on 4/21/24.
//

import UIKit
import SnapKit

final class EmailView: ModeBaseView {
    
    let titleLabel = DRLabel(text: "이메일을\n입력해주세요.", style: .title)
    let emailTextField = DRTextField(title: "이메일")
    let validButton = DRButton(title: "중복확인")
    let nextButton = DRButton(title: "다음")
    
    override func configureHierarchy() {
        [titleLabel, emailTextField, validButton, nextButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(emailTextField.basicHeight)
        }
        
        validButton.snp.makeConstraints { make in
            make.leading.equalTo(emailTextField.snp.trailing).offset(4)
            make.bottom.equalTo(emailTextField)
            make.width.equalTo(72)
            make.height.equalTo(48)
            make.trailing.equalToSuperview().inset(20)
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
        validButton.isEnabled = false
        emailTextField.keyboardType = .emailAddress
    }
    
    override func configureMode() {
        switch mode {
        case .basic:
            break
        case .modify:
            validButton.isHidden = true
            emailTextField.snp.remakeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(40)
                make.horizontalEdges.equalToSuperview().inset(20)
                make.height.equalTo(emailTextField.basicHeight)
            }
        }
    }
    
}
