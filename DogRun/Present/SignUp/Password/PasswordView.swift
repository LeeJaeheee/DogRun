//
//  PasswordView.swift
//  DogRun
//
//  Created by 이재희 on 4/21/24.
//

import Foundation
import SnapKit

final class PasswordView: BaseView {
    
    let titleLabel = DRLabel(text: "비밀번호를 입력해주세요", style: .title)
    let passwordTextField = DRTextField(title: "비밀번호")
    let nextButton = DRButton(title: "다음")
    
    override func configureHierarchy() {
        [titleLabel, passwordTextField, nextButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(70)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(passwordTextField.basicHeight)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(60)
            make.height.equalTo(nextButton.basicHeight)
        }
    }
    
    override func configureView() {
        nextButton.isEnabled = false
    }
    
}
