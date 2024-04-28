//
//  PhoneNumberView.swift
//  DogRun
//
//  Created by 이재희 on 4/28/24.
//

import Foundation
import SnapKit

final class PhoneNumberView: ModeBaseView {
    
    let titleLabel = DRLabel(text: "휴대폰 번호를\n입력해주세요.", style: .title)
    let phoneNumberTextField = DRTextField(title: "휴대폰 번호")
    let nextButton = DRButton(title: "다음")
    
    override func configureHierarchy() {
        [titleLabel, phoneNumberTextField, nextButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(phoneNumberTextField.basicHeight)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(60)
            // FIXME: 아래 코드로 실행하면 textfieldeffects에서 문제생김 (animateViewsForTextEntry() 호출안함)
            //make.bottom.equalTo(keyboardLayoutGuide.snp.top).inset(-16)
            make.height.equalTo(nextButton.basicHeight)
        }
    }
    
    override func configureView() {
        nextButton.isEnabled = false
        phoneNumberTextField.keyboardType = .numberPad
    }
    
}
