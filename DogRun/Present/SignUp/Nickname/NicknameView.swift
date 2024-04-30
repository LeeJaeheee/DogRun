//
//  NicknameView.swift
//  DogRun
//
//  Created by 이재희 on 4/21/24.
//

import Foundation
import SnapKit

final class NicknameView: BaseView {
    
    let titleLabel = DRLabel(text: "닉네임을\n입력해주세요.", style: .title)
    let nicknameTextField = DRTextField(title: "닉네임")
    let countLabel = DRLabel(text: "0/10", style: .body)
    let nextButton = DRButton(title: "다음")
    
    override func configureHierarchy() {
        [titleLabel, nicknameTextField, countLabel, nextButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(nicknameTextField.basicHeight)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(12)
            make.leading.equalTo(nicknameTextField).offset(16)
            make.height.equalTo(20)
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
    }
    
}
