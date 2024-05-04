//
//  WelcomeView.swift
//  DogRun
//
//  Created by 이재희 on 4/27/24.
//

import UIKit
import SnapKit

final class WelcomeView: BaseView {
    let logoImageView = UIImageView()
    let titleLabel = UILabel()
    let subLabel = UILabel()
    
    let signUpButton = DRVariableButton(title: "도그런 회원가입", style: .filled, image: .init(systemName: "envelope.badge"))
    let signInButton = DRVariableButton(title: "이메일로 로그인", style: .outlined, image: .init(systemName: "pawprint.fill"))
    
    override func configureHierarchy() {
        [logoImageView, titleLabel, subLabel, signUpButton, signInButton].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.size.equalTo(150)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        signInButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(40)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(signInButton.basicHeight)
        }
        signUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(signInButton.snp.top).offset(-16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(signInButton.basicHeight)
        }
    }
    
    override func configureView() {
        logoImageView.backgroundColor = .accent
        
        titleLabel.text = "환영합니다."
        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
        
        subLabel.text = "도그런과 함께하실 준비되셨나요?"
        subLabel.font = .systemFont(ofSize: 19, weight: .medium)
        subLabel.textColor = .gray
    }
}
