//
//  UserProfileTableViewCell.swift
//  DogRun
//
//  Created by 이재희 on 4/24/24.
//

import UIKit
import SnapKit

final class UserProfileTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    let contentLabel = UILabel()
    
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
        [titleLabel, contentLabel].forEach { contentView.addSubview($0)}
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(20)
            make.trailing.lessThanOrEqualToSuperview()
            make.height.equalTo(16)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(20)
            make.trailing.lessThanOrEqualToSuperview()
            make.height.equalTo(24)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func configureView() {
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .systemGray
        
        contentLabel.font = .systemFont(ofSize: 17, weight: .semibold)
    }

}
