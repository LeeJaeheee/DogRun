//
//  NicknameView.swift
//  DogRun
//
//  Created by 이재희 on 4/21/24.
//

import Foundation
import SnapKit

final class NicknameView: BaseView {
    
    let titleLabel = DRLabel(text: "닉네임을 입력해주세요", style: .title)
    let nicknameTextField = DRTextField(title: "닉네임")
    let doneButton = DRButton(title: "가입하기")
    
    override func configureHierarchy() {
        [titleLabel, nicknameTextField, doneButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(40)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(70)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(nicknameTextField.basicHeight)
        }
        
        doneButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(60)
            make.height.equalTo(doneButton.basicHeight)
        }
    }
    
    override func configureView() {
        doneButton.isEnabled = false
    }
    
}
