//
//  UserView.swift
//  DogRun
//
//  Created by 이재희 on 4/23/24.
//

import UIKit

final class UserView: BaseView {

    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let profileView = UserHeaderView()
    let containerView = UIView()
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(profileView)
        contentView.addSubview(containerView)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        profileView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView)
            make.height.equalTo(250)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom)
            make.bottom.horizontalEdges.equalTo(contentView)
            make.height.equalTo(safeAreaLayoutGuide.snp.height)
        }
    }
    
    override func configureView() {
        
    }

}
