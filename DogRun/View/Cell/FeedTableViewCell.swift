//
//  UserFeedTableViewCell.swift
//  DogRun
//
//  Created by 이재희 on 4/27/24.
//

import UIKit
import SwiftUI
import SnapKit

extension UIColor {
    var color: Color {
        Color(self)
    }
}

extension String: Identifiable {
    public var id: String {
        String(describing: self)
    }
}

class FeedTableViewCell: UITableViewCell {

    let profileView = UIImageView()
    let likeButton = UIButton()
    let commentButton = UIButton()
    
    var hostingController: UIHostingController<AnyView>? = nil

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hostingController?.view.removeFromSuperview()
        hostingController = nil
    }
    
    func configureHierarchy() {
        [profileView, likeButton, commentButton].forEach { contentView.addSubview($0) }
    }
    
    func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.size.equalTo(60)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(200)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(60)
        }
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).offset(16)
            make.size.equalTo(60)
            make.leading.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configureView() {
        profileView.backgroundColor = .yellow
        likeButton.backgroundColor = .green
        commentButton.backgroundColor = .accent
    }
    
    func configureImages(with files: [String]) {
        let cardStack = CardStack(files) { imageURLString in
            ImageCardView(imageURLString: "https://picsum.photos/200")
        }
        
        let hostingController = UIHostingController(rootView: AnyView(cardStack))
        self.hostingController = hostingController
        
        guard let hostingView = hostingController.view else { return }
        contentView.addSubview(hostingView)
        contentView.sendSubviewToBack(hostingView)
        
        hostingView.snp.makeConstraints { make in
            make.leading.equalTo(likeButton.snp.trailing).offset(-20)
            make.top.equalTo(profileView.snp.bottom)
            make.trailing.bottom.equalToSuperview()
        }
    }
    
}
