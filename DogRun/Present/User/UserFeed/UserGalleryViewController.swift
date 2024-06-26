//
//  UserGalleryViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class UserGalleryViewController: UIViewController {
    
    let viewModel = UserGalleryViewModel()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    let refreshControl = UIRefreshControl()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.refreshControl = refreshControl
        
        bind()
    }
    
    func bind() {
        let input = UserGalleryViewModel.Input(
            loadTrigger: BehaviorRelay(value: ()), 
            fetchMoreDatas: collectionView.rx.willDisplayCell.map { $0.at.item },
            refreshTrigger: refreshControl.rx.controlEvent(.valueChanged)
        )
        
        let output = viewModel.transform(input: input)
        
        output.files
            .drive(collectionView.rx.items(cellIdentifier: ImageCollectionViewCell.identifier, cellType: ImageCollectionViewCell.self)) { index, imageURL, cell in
                cell.imageView.kf.setImage(with: URL(string: APIKey.baseURL.rawValue+"/"+imageURL))
        }
        .disposed(by: disposeBag)
        
        output.posts
            .drive(with: self) { owner, _ in
                owner.collectionView.refreshControl?.endRefreshing()
            }
            .disposed(by: disposeBag)
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        // TODO: 열거형으로 정리하기(중복제거)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let defaultItem = NSCollectionLayoutItem(layoutSize: itemSize)
        defaultItem.contentInsets = .init(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1/3))
        let defaultGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [defaultItem])
        
        let largeItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1.0)))
        largeItem.contentInsets = .init(top: 1, leading: 1, bottom: 1, trailing: 1)
        let smallItems = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1/2)))
        smallItems.contentInsets = .init(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        let smallItemsGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)),
            repeatingSubitem: smallItems, count: 2)

        let largeLeadingGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/3)),
            subitems: [largeItem, smallItemsGroup])
        
        let largeTrailingGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/3)),
            subitems: [smallItemsGroup, largeItem])
        
        let mainGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(800)), subitems: [largeLeadingGroup, defaultGroup, largeTrailingGroup, defaultGroup])
        
        let section = NSCollectionLayoutSection(group: mainGroup)
        section.contentInsets = .init(top: 2, leading: 0, bottom: 0, trailing: 0)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
