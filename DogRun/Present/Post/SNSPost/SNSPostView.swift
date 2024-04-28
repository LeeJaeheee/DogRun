//
//  SNSPostView.swift
//  DogRun
//
//  Created by 이재희 on 4/23/24.
//

import UIKit
import SnapKit

final class SNSPostView: BaseView {
    
    // 테스트
    let loginButton = UIButton()
    let loadPostButton = UIButton()

    let containerView = UIView()
    
    override func configureHierarchy() {
        addSubview(containerView)
    }
    
    override func configureLayout() {
//        addSubview(loginButton)
//        loginButton.snp.makeConstraints { make in
//            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
//            make.height.equalTo(40)
//        }
//        loginButton.setTitle("로그인", for: .normal)
//        loginButton.backgroundColor = .blue
//        
//        addSubview(loadPostButton)
//        loadPostButton.snp.makeConstraints { make in
//            make.top.equalTo(loginButton.snp.bottom).offset(16)
//            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
//            make.height.equalTo(40)
//        }
//        loadPostButton.setTitle("포스트", for: .normal)
//        loadPostButton.backgroundColor = .blue
        
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {

    }

}
