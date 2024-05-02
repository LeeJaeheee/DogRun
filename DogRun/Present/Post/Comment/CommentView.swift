//
//  CommentView.swift
//  DogRun
//
//  Created by 이재희 on 5/2/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CommentView: BaseView {
    let disposeBag = DisposeBag()
    
    let tableView = UITableView()
    let textBackgroundView = UIView()
    let textView = UITextView()
    let sendButton = UIButton()
    
    override func configureHierarchy() {
        [tableView, textBackgroundView, textView, sendButton].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        
        textView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(48)
            make.height.lessThanOrEqualTo(80)
            //make.top.equalTo(textBackgroundView.snp.top).offset(8)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        textBackgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(textView).offset(-8)
        }
        
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(textView).offset(-6)
            make.size.equalTo(36)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-64)
        }
    }
    
    override func configureView() {
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        sendButton.setImage(UIImage(systemName: "paperplane.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28)), for: .normal)
        sendButton.isHidden = true
        
        textBackgroundView.backgroundColor = .white
        
        textView.backgroundColor = .systemGray6
        textView.font = .systemFont(ofSize: 18)
        textView.layer.cornerRadius = 24
        textView.clipsToBounds = true
        textView.textContainerInset = .init(top: 16, left: 8, bottom: 12, right: 48)
        textView.showsVerticalScrollIndicator = false
        
        textViewBind()

    }
    
    private func textViewBind() {
        textView.rx.text
            .bind(with: self) { owner, _ in
                let size = CGSize(width: owner.textView.frame.width, height: .infinity)
                let estimatedSize = owner.textView.sizeThatFits(size)
                let isMaxHeight = estimatedSize.height >= 80
                
                guard isMaxHeight != owner.textView.isScrollEnabled else { return }
                owner.textView.isScrollEnabled = isMaxHeight
                owner.textView.reloadInputViews()
                owner.setNeedsUpdateConstraints()

            }
            .disposed(by: disposeBag)
    }
}
