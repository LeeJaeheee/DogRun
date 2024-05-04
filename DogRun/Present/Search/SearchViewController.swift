//
//  SearchViewController.swift
//  DogRun
//
//  Created by 이재희 on 5/4/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: BaseViewController<SearchView> {
    let viewModel = SearchViewModel()
    
    var imageSizes: [Int: CGSize] = [:]
    
    override func bind() {
        let input = SearchViewModel.Input(
            searchButtonTap: mainView.searchController.searchBar.rx.searchButtonClicked,
            searchText: mainView.searchController.searchBar.rx.text.orEmpty,
            modelSelected: mainView.collectionView.rx.modelSelected(PostResponse.self))
        
        let output = viewModel.transform(input: input)
        //해시태그
        output.searchResults
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: PinterestCollectionViewCell.identifier, cellType: PinterestCollectionViewCell.self)) { index, post, cell in
                cell.profileView.configureData(data: post)
                cell.hashtagLabel.text = post.hashTags.hashtagsString()
                
                if let image = post.files?.first {
                    cell.imageView.kf.setImage(with: URL(string: APIKey.baseURL.rawValue+"/"+image)) { result in
                        switch result {
                        case .success(let success):
                            self.imageSizes[index] = success.image.size
                            print("이미지사이즈으으으", success.image.size)
                        case .failure(_):
                            break
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
        
        output.searchFailure
            .bind(with: self) { owner, error in
                owner.errorHandler(error)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureNavigation() {
        navigationItem.searchController = mainView.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func configureView() {
        if let layout = mainView.collectionView.collectionViewLayout as? PinterestLayout {
            print("핀터레스트레이아웃뜨")
          layout.delegate = self
        }
    }
}

extension SearchViewController: PinterestLayoutDelegate {
    
    // 이미지 height
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        print(#function, indexPath)
        guard let imageSize = imageSizes[indexPath.row] else {
            return 0
        }
        print(indexPath, imageSize)
//        let aspectRatio = imageSize.width / imageSize.height
//        let targetWidth = collectionView.frame.width
//        let targetHeight = targetWidth / aspectRatio
        return imageSize.height
    }
    
}
