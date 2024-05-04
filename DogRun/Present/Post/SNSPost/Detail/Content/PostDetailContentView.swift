//
//  PostDetailContentView.swift
//  DogRun
//
//  Created by 이재희 on 5/4/24.
//

import UIKit

final class PostDetailContentView: BaseView {
    let profileView = ProfileInfoView()
    let hashtagLabel = UILabel()
    let contentTextView = UITextView()
    let textView = UIView()
    
    override func configureHierarchy() {
        [profileView, hashtagLabel, contentTextView].forEach { addSubview($0) }
        addSubview(textView)
    }
    
    override func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(8)
            make.horizontalEdges.equalToSuperview()
        }
        
        hashtagLabel.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.lessThanOrEqualTo(24)
        }
        
        textView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(40)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(hashtagLabel.snp.bottom)
            make.bottom.equalTo(textView.snp.top).offset(-20)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    override func configureView() {
        hashtagLabel.textColor = .accent
        
        contentTextView.textContainerInset = .init(top: 16, left: 20, bottom: 16, right: 20)
        contentTextView.isEditable = false
        contentTextView.font = .systemFont(ofSize: 17)
        
    }
    
    func configureData(data: PostResponse) {
        profileView.configureData(data: data)
        
        // TODO: 데이터 연결하기
        hashtagLabel.text = data.hashTags.hashtagsString()
        contentTextView.text = data.content
        textView.backgroundColor = .blue
    }
}
