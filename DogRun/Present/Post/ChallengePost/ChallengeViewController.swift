//
//  ChallengeViewController.swift
//  DogRun
//
//  Created by 이재희 on 5/6/24.
//

import UIKit

final class ChallengeViewController: BaseViewController<ChallengeView> {
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    override func configureView() {
        setDataSource()
        setSnapShot()
    }
    
    override func bind() {
        
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item> (collectionView: mainView.collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self else { return UICollectionViewCell() }
            
            switch itemIdentifier {
            case .banner(let item):
                guard let cell = mainView.collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as? BannerCollectionViewCell else { return UICollectionViewCell() }
                
                return cell
            case .recommend(let item):
                guard let cell = mainView.collectionView.dequeueReusableCell(withReuseIdentifier: NormalCarouselCollectionViewCell.identifier, for: indexPath) as? NormalCarouselCollectionViewCell else { return UICollectionViewCell() }
                
                return cell
            case .post(let item):
                guard let cell = mainView.collectionView.dequeueReusableCell(withReuseIdentifier: ListCarouselCollectionViewCell.identifier, for: indexPath) as? ListCarouselCollectionViewCell else { return UICollectionViewCell() }
                
                return cell
            }

        })
    }
    
    private func setSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        let bannerSection = Section(id: SectionType.banner.rawValue)
        snapshot.appendSections([bannerSection])
        let bannerItems: [Item] = []
        snapshot.appendItems(bannerItems, toSection: bannerSection)
        
        let recommendSection = Section(id: SectionType.normalCarousel.rawValue)
        snapshot.appendSections([recommendSection])
        let recommendItems: [Item] = []
        snapshot.appendItems(recommendItems, toSection: recommendSection)
        
        let postSection = Section(id: SectionType.listCarousel.rawValue)
        snapshot.appendSections([postSection])
        let postItems: [Item] = []
        snapshot.appendItems(postItems, toSection: postSection)
        
        dataSource?.apply(snapshot)
    }
}
