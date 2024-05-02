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
    let likeCountLabel = DRLabel(text: "", style: .count)
    let commentCountLabel = DRLabel(text: "", style: .count)
    
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
        
        likeButton.tintColor = .white
        profileView.backgroundColor = .systemGray6
    }
    
    func configureHierarchy() {
        [profileView, nicknameLabel, dateLabel, likeButton, likeCountLabel, commentButton, commentCountLabel].forEach { contentView.addSubview($0) }
    }
    
    func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
            make.size.equalTo(60)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileView.snp.trailing).offset(12)
            make.top.equalTo(profileView.snp.top).offset(4)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(26)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(nicknameLabel.snp.bottom)
            make.height.equalTo(20)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(180)
            make.centerX.equalTo(profileView)
            make.size.equalTo(52)
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom)
            make.centerX.equalTo(profileView)
            make.height.equalTo(16)
        }
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(likeCountLabel.snp.bottom).offset(4)
            make.size.equalTo(52)
            make.centerX.equalTo(profileView)
        }
        
        commentCountLabel.snp.makeConstraints { make in
            make.top.equalTo(commentButton.snp.bottom)
            make.centerX.equalTo(profileView)
            make.height.equalTo(16)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    func configureView() {
        
        profileView.layer.cornerRadius = 20
        profileView.clipsToBounds = true
        
        nicknameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        dateLabel.font = .systemFont(ofSize: 13, weight: .light)
        dateLabel.textColor = .lightGray
        
        var imageConfig = UIImage.SymbolConfiguration(pointSize: 36, weight: .light)
        likeButton.setImage(UIImage(systemName: "bolt.heart.fill", withConfiguration: imageConfig), for: .normal)
        likeButton.backgroundColor = .systemGray6
        likeButton.layer.cornerRadius = 26
        likeButton.tintColor = .white
        
        imageConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .light)
        commentButton.setImage(UIImage(systemName: "ellipsis.bubble.fill", withConfiguration: imageConfig), for: .normal)
        commentButton.backgroundColor = .systemGray6
        commentButton.layer.cornerRadius = 26
        commentButton.tintColor = .white
        
        selectionStyle = .none
    }
    
    func configureImages(with files: [String]) {
        let cardStack = CardStack(files, currentIndex: .constant(0)) { imageURLString, index in
            ImageCardView(imageURLString: APIKey.baseURL.rawValue+"/"+imageURLString){
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
            make.top.equalTo(profileView.snp.bottom).offset(12)
            make.trailing.bottom.equalToSuperview()
        }
        
        hostingView.backgroundColor = .clear
    }
    
    func configureData(data: PostResponse) {
        if let profileImage = data.creator.profileImage {
            profileView.kf.setImage(with: URL(string: APIKey.baseURL.rawValue+"/"+profileImage))
        } else {
            profileView.image = UIImage(systemName: "person")
        }
        nicknameLabel.text = data.creator.nick
        dateLabel.text = data.createdAt
        likeButton.tintColor = data.likes.contains( UserDefaultsManager.userId) ? .systemRed : .white
        likeCountLabel.text = String(data.likes.count)
        commentCountLabel.text = String(data.comments.count)
        
        if let files = data.files {
            configureImages(with: files)
        }
    }
    
}

/*
final class FeedTableViewCellViewModel {
    let disposeBag = DisposeBag()
    
    let likeButtonTap: ControlEvent<Void>
    let post = PublishRelay<PostResponse>()
    let likeSuccess = PublishRelay<Bool>()
    let likeFailure = PublishRelay<DRError>()
    
    init(likeButtonTap: ControlEvent<Void>) {
        self.likeButtonTap = likeButtonTap
        
        likeButtonTap
            .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .flatMap { self.post }
            .flatMap { value in
                return NetworkManager.request2(type: LikeModel.self, router: LikeRouter.like(postId: value.post_id, model: .init(like_status: !value.likes.contains(UserDefaultsManager.userId))))
            }
            .bind(with: self) { owner, response in
                switch response {
                case .success(let success):
                    owner.likeSuccess.accept(success.like_status)
                case .failure(let failure):
                    owner.likeFailure.accept(failure)
                }
            }
            .disposed(by: disposeBag)
    }
}
*/
