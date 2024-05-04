//
//  SearchView.swift
//  DogRun
//
//  Created by 이재희 on 5/4/24.
//

import UIKit

final class SearchView: BaseView {
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.placeholder = "검색어를 입력하세요"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.definesPresentationContext = true
        
       return searchController
    }()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: PinterestLayout())
    
    override func configureHierarchy() {
        addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        collectionView.register(PinterestCollectionViewCell.self, forCellWithReuseIdentifier: PinterestCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
    }
}
