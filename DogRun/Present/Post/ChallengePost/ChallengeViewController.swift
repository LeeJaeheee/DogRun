//
//  ChallengeViewController.swift
//  DogRun
//
//  Created by 이재희 on 5/6/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ChallengeViewController: BaseViewController<ChallengeView> {
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    
    let viewModel = ChallengeViewModel()
    
    override func configureView() {
        setDataSource()
        snapshot.appendSections([.init(id: SectionType.banner.rawValue), .init(id: SectionType.normalCarousel.rawValue), .init(id: SectionType.listCarousel.rawValue)])
    }
    
    override func bind() {
        let input = ChallengeViewModel.Input(loadBannerTrigger: BehaviorRelay<Void>(value: ()), loadChallengeTrigger: BehaviorRelay(value: ()))
        
        let output = viewModel.transform(input: input)
        
        output.bannerList
            .drive(with: self) { owner, banners in
                let items = banners.map { Item.banner($0) }
                owner.snapshot.appendItems(items, toSection: .init(id: SectionType.banner.rawValue))
                owner.dataSource?.apply(owner.snapshot)
            }
            .disposed(by: disposeBag)
        
        output.recommendList
            .drive(with: self) { owner, recommends in
                let items = recommends.map { Item.recommend($0) }
                owner.snapshot.appendItems(items, toSection: .init(id: SectionType.normalCarousel.rawValue))
                owner.dataSource?.apply(owner.snapshot)
            }
            .disposed(by: disposeBag)
        
        output.postList
            .drive(with: self) { owner, posts in
                let items = posts.map { Item.post($0) }
                owner.snapshot.appendItems(items, toSection: .init(id: SectionType.listCarousel.rawValue))
                owner.dataSource?.apply(owner.snapshot)
            }
            .disposed(by: disposeBag)
        
        output.requestFailure
            .bind(with: self) { owner, error in
                owner.errorHandler(error)
            }
            .disposed(by: disposeBag)
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item> (collectionView: mainView.collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self else { return UICollectionViewCell() }
            
            switch itemIdentifier {
            case .banner(let item):
                guard let cell = mainView.collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as? BannerCollectionViewCell else { return UICollectionViewCell() }
                cell.configureData(title: item.title)
                return cell
            case .recommend(let item):
                guard let cell = mainView.collectionView.dequeueReusableCell(withReuseIdentifier: NormalCarouselCollectionViewCell.identifier, for: indexPath) as? NormalCarouselCollectionViewCell else { return UICollectionViewCell() }
                cell.configureData(data: item)
                cell.registerButton.rx.tap
                    .debounce(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
                    .bind(with: self) { owner, _ in
                        owner.viewModel.registerIndex.accept(indexPath.item)
                    }
                    .disposed(by: cell.disposeBag)
                return cell
            case .post(let item):
                guard let cell = mainView.collectionView.dequeueReusableCell(withReuseIdentifier: ListCarouselCollectionViewCell.identifier, for: indexPath) as? ListCarouselCollectionViewCell else { return UICollectionViewCell() }
                cell.configureData(data: item)
                return cell
            }

        })
    }
    
}
