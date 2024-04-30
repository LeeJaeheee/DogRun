//
//  JoinGreetingView.swift
//  DogRun
//
//  Created by 이재희 on 4/30/24.
//

import UIKit
import SnapKit

final class JoinGreetingView: BaseView {
    let logoImageView = UIImageView()
    let titleLabel = UILabel()
    let subLabel = UILabel()
    
    let signInButton = DRButton(title: "시작하기")
    
    override func configureHierarchy() {
        [logoImageView, titleLabel, subLabel, signInButton].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(200)
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
            make.bottom.equalTo(safeAreaLayoutGuide).inset(signInButton.basicBottomInset)
            make.horizontalEdges.equalToSuperview().inset(signInButton.basicHorizontalInset)
            make.height.equalTo(signInButton.basicHeight)
        }
    }
    
    override func configureView() {
        logoImageView.image = UIImage(systemName: "checkmark.circle.fill")
        logoImageView.tintColor = .systemGreen
        
        titleLabel.text = "회원가입 완료"
        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
        
        subLabel.text = "지금 바로 도그런과 함께 달려볼까요?"
        subLabel.font = .systemFont(ofSize: 19, weight: .medium)
        subLabel.textColor = .gray
    }
}
