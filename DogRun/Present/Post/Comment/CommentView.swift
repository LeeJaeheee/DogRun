//
//  CommentView.swift
//  DogRun
//
//  Created by 이재희 on 5/2/24.
//

import UIKit

final class CommentView: BaseView {
    
    let tableView = UITableView()
    let textBackgroundView = UIView()
    let textView = UITextView()
    let sendButton = UIButton()
    
    override func configureHierarchy() {
        [tableView, textBackgroundView].forEach { addSubview($0) }
        [textView, sendButton].forEach { textBackgroundView.addSubview($0) }
    }
    
    override func configureLayout() {
        textBackgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(keyboardLayoutGuide.snp.top)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.lessThanOrEqualTo(85)
            make.height.greaterThanOrEqualTo(48)
        }
        
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(14)
            make.size.equalTo(36)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(textBackgroundView.snp.top)
        }
    }
    
    override func configureView() {
        sendButton.setImage(UIImage(systemName: "paperplane.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28)), for: .normal)
        
        textBackgroundView.backgroundColor = .white
        
        textView.backgroundColor = .systemGray6
        textView.font = .systemFont(ofSize: 18)
        textView.layer.cornerRadius = 24
        textView.clipsToBounds = true
        textView.textContainerInset = .init(top: 12, left: 8, bottom: 12, right: 40)
        textView.showsVerticalScrollIndicator = false
    }
}
