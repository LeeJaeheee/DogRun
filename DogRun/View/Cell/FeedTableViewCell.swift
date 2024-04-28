//
//  UserFeedTableViewCell.swift
//  DogRun
//
//  Created by 이재희 on 4/27/24.
//

import UIKit
import SwiftUI
import SnapKit
import RxSwift
import RxCocoa

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
    var tapImageCardSubject = PublishSubject<Int>()
    var disposeBag = DisposeBag()

    let profileView = UIImageView()
    let nicknameLabel = UILabel()
    let dateLabel = UILabel()
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
        [profileView, nicknameLabel, dateLabel, likeButton, commentButton].forEach { contentView.addSubview($0) }
    }
    
    func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.size.equalTo(60)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileView.snp.trailing).offset(12)
            make.top.equalTo(profileView.snp.top)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(nicknameLabel.snp.bottom)
            make.height.equalTo(20)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(200)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(60)
        }
        likeButton.imageView!.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).offset(4)
            make.size.equalTo(60)
            make.leading.bottom.equalToSuperview().inset(16)
        }
        commentButton.imageView!.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    func configureView() {
        profileView.backgroundColor = .yellow
        profileView.layer.cornerRadius = 30
        
        nicknameLabel.font = .systemFont(ofSize: 17, weight: .medium)
        dateLabel.font = .systemFont(ofSize: 15, weight: .light)
        dateLabel.textColor = .lightGray
        
        likeButton.setImage(UIImage(systemName: "heart.circle.fill"), for: .normal)
        likeButton.tintColor = .systemGray5
        commentButton.setImage(UIImage(systemName: "bubble.left.circle.fill"), for: .normal)
        commentButton.tintColor = .systemGray5
        
        nicknameLabel.text = "닉네임"
        dateLabel.text = "45분 전"
    }
    
    func configureImages(with files: [String]) {
        let cardStack = CardStack(files, currentIndex: .constant(0)) { imageURLString, index in
            ImageCardView(imageURLString: "https://picsum.photos/200"){
                print("\(index) ImageCardView 탭됨")
                self.tapImageCardSubject.onNext(index)
            }
        }
        
        let hostingController = UIHostingController(rootView: AnyView(cardStack))
        self.hostingController = hostingController
        
        guard let hostingView = hostingController.view else { return }
        contentView.addSubview(hostingView)
        contentView.sendSubviewToBack(hostingView)
        
        hostingView.snp.makeConstraints { make in
            make.leading.equalTo(likeButton.snp.trailing).offset(-30)
            make.top.equalTo(profileView.snp.bottom)
            make.trailing.bottom.equalToSuperview()
        }
    }
    
}
