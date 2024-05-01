//
//  TextViewCollectionViewCell.swift
//  DogRun
//
//  Created by 이재희 on 5/1/24.
//

import UIKit
import SnapKit

protocol TextViewCollectionViewCellDelegate: AnyObject {
    func textViewDidChangeInCell(text: String)
}

class TextViewCollectionViewCell: BaseCollectionViewCell {
    
    weak var delegate: TextViewCollectionViewCellDelegate?
    
    let containerView = DROpaqueView()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        //textView.font = Constant.Font.basic(size: 24).font
        textView.backgroundColor = .clear
        return textView
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(textView)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        textView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(70)
            //make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    override func configureView() {
        containerView.backgroundColor = .systemBackground
        textView.textContainerInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        textView.delegate = self
        textView.font = .systemFont(ofSize: 17)
    }
    
    @objc func done() {
        self.textView.endEditing(true)
    }
    
    func configureText(text: String) {
        if text.isEmpty {
            textView.text = "여기에 내용을 입력하세요."
            textView.textColor = .lightGray
        } else {
            textView.text = text
            textView.textColor = .black
        }
        
        textView.layoutIfNeeded()
        
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.infinity))
        let maxHeight = 400.0
        
        if size.height >= maxHeight {
            textView.isScrollEnabled = true
            textView.snp.updateConstraints {
                $0.height.equalTo(maxHeight)
            }
        } else {
            textView.isScrollEnabled = false
            textView.snp.updateConstraints {
                $0.height.equalTo(size.height)
            }
        }
        
        layoutIfNeeded()
         
    }
    
}

extension TextViewCollectionViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        if newText.isEmpty {
            textView.text = "여기에 내용을 입력하세요."
            textView.textColor = .lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if textView.textColor == .lightGray && !newText.isEmpty {
            textView.text = nil
            textView.textColor = .black
        }
        
        delegate?.textViewDidChangeInCell(text: newText)
        
        return true
    }
    func textViewDidChange(_ textView: UITextView) {

        //let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.infinity))
        textView.sizeToFit()
        
        let maxHeight = 400.0
        let height = min(maxHeight, textView.frame.height)
        
        textView.isScrollEnabled = height == maxHeight
        textView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }

        delegate?.textViewDidChangeInCell(text: textView.textColor == .lightGray ? "" : textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "여기에 내용을 입력하세요."
            textView.textColor = .lightGray
        }
    }
}
