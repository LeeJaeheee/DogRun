//
//  PostDetailContentViewController.swift
//  DogRun
//
//  Created by 이재희 on 5/4/24.
//

import UIKit

final class PostDetailContentViewController: BaseViewController<PostDetailContentView> {
    
    var post: PostResponse
    
    init(post: PostResponse) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        mainView.configureData(data: post)
    }
    
}
