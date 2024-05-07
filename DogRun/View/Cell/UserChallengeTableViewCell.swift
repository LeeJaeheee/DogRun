//
//  UserChallengeTableViewCell.swift
//  DogRun
//
//  Created by 이재희 on 4/27/24.
//

import UIKit
import SnapKit

class UserChallengeTableViewCell: UITableViewCell {
    
    let containerView = UIView()
    
    let mainImageView = UIImageView()
    
    let titleLabel = UILabel()
    let button = DRButton(title: "인증하기")

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        contentView.addSubview(containerView)
        [mainImageView, titleLabel, button].forEach { containerView.addSubview($0) }
    }
    
    private func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(mainImageView.snp.width).multipliedBy(0.5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(20)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(button.basicHeight)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    private func configureView() {
        selectionStyle = .none
        mainImageView.backgroundColor = .init(
            red: 0.5 + CGFloat.random(in: 0...0.5),
            green: 0.5 + CGFloat.random(in: 0...0.5),
            blue: 0.5 + CGFloat.random(in: 0...0.5),
            alpha: 0.8
        )
        
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 20
        containerView.layer.borderColor = UIColor.systemGray5.cgColor
        containerView.layer.borderWidth = 2
        
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 18, weight: .heavy)

    }
    
}
