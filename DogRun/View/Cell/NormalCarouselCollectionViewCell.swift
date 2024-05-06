//
//  NormalCarouselCollectionViewCell.swift
//  DogRun
//
//  Created by 이재희 on 5/6/24.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift

final class NormalCarouselCollectionViewCell: BaseCollectionViewCell {
    
    var disposeBag = DisposeBag()

    private let containerView = UIView()
    private let mainImage = UIImageView()
    private let titleContainerView = UIView()
    private let titleLabel = DRLabel(text: "", style: .title)
    private let subLabel = DRLabel(text: "", style: .subtitle)
    private let bookmarkButton = UIButton()
    private let regionLabel = UILabel()
    private let priceLabel = UILabel()
    let registerButton = DRButton(title: "참여하기")
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(containerView)
        [mainImage, titleContainerView, bookmarkButton, registerButton].forEach { containerView.addSubview($0) }
        [titleLabel, subLabel, regionLabel, priceLabel].forEach { titleContainerView.addSubview($0) }
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleContainerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        regionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.trailing.equalTo(containerView.snp.centerX).offset(-4)
            make.height.equalTo(20)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(regionLabel)
            make.leading.equalTo(containerView.snp.centerX).offset(4)
            make.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.horizontalEdges.equalToSuperview().inset(16)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().multipliedBy(0.95)
            make.size.equalTo(50)
        }
        
        registerButton.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
    }
    
    override func configureView() {
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        
        titleContainerView.backgroundColor = .init(white: 0.3, alpha: 0.75)
        titleLabel.textColor = .white
        subLabel.textColor = .systemGray6
        subLabel.font = .systemFont(ofSize: 16)
        subLabel.textAlignment = .center
        
        [regionLabel, priceLabel].forEach { label in
            label.backgroundColor = .init(white: 1.0, alpha: 0.6)
            label.font = .systemFont(ofSize: 14, weight: .bold)
            label.textColor = .black
            label.layer.cornerRadius = 4
            label.clipsToBounds = true
        }
        
        bookmarkButton.setImage(.init(systemName: "bookmark.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50)), for: .normal)
        bookmarkButton.tintColor = .white
    }
    
    func configureData(data: ChallengeResponse) {
        titleLabel.text = data.title
        subLabel.text = data.content
        mainImage.kf.setImage(with: URL(string: data.imageStrings.first!))
        bookmarkButton.tintColor = data.isLiked ? .systemRed : .white
        regionLabel.text = "  \(data.region)  "
        priceLabel.text = "  \(data.price)원  "
    }

}
