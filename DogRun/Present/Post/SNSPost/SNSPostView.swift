//
//  SNSPostView.swift
//  DogRun
//
//  Created by 이재희 on 4/23/24.
//

import UIKit
import SnapKit

final class SNSPostView: BaseView {

    let containerView = UIView()
    
    override func configureHierarchy() {
        addSubview(containerView)
    }
    
    override func configureLayout() {
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {

    }

}
