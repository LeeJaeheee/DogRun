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
    
    var imageSizes: [Int: (CGSize, UIImage?)] = [:]
    
    override func bind() {
        let input = SearchViewModel.Input(
            searchButtonTap: mainView.searchController.searchBar.rx.searchButtonClicked,
            searchText: mainView.searchController.searchBar.rx.text.orEmpty,
            modelSelected: mainView.collectionView.rx.modelSelected(PostResponse.self))
        
        let output = viewModel.transform(input: input)
        //해시태그 도그런 먹방
        
        output.searchButtonTap
            .drive(with: self) { owner, _ in
                if let layout = owner.mainView.collectionView.collectionViewLayout as? PinterestLayout {
                    layout.clearCache()
                }
            }
            .disposed(by: disposeBag)
        
        output.searchResults
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .flatMapLatest { owner, posts in
                owner.imageSizes = [:]
                let urlStrings = posts.compactMap { $0.files?.first }.map { $0 }
                return Observable.create { observer in
                    self.preloadImages(urlStrings: urlStrings) { imageInfo in
                        observer.onNext(imageInfo)
                        observer.onCompleted()
                    }
                    return Disposables.create()
                }
            }
            .do { [weak self] imageInfo in
                self?.imageSizes = imageInfo
            }
            .withLatestFrom(output.searchResults)
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: PinterestCollectionViewCell.identifier, cellType: PinterestCollectionViewCell.self)) { index, post, cell in
                cell.profileView.configureData(data: post)
                cell.hashtagLabel.text = post.hashTagsString
                cell.imageView.image = self.imageSizes[index]?.1
                
                cell.profileView.tapGesture.rx.event
                    .debounce(.milliseconds(5), scheduler: MainScheduler.asyncInstance)
                    .bind(with: self) { owner, _ in
                        let vc = UserViewController()
                        vc.viewModel.userId = post.creator.user_id
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.modelSelected
            .drive(with: self) { owner, post in
                let vc = PostDetailViewController()
                vc.post = post
                vc.modalPresentationStyle = .fullScreen
                vc.view.backgroundColor = UIColor.clear
                owner.present(vc, animated: false) {
                    vc.view.alpha = 0.5
                    UIView.animate(withDuration: 0.8, animations: {
                        vc.view.backgroundColor = UIColor.white.withAlphaComponent(1.0)
                        vc.view.alpha = 1.0
                    })
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
        let aspectRatio = imageSize.0.width / imageSize.0.height
        let targetWidth = collectionView.frame.width / 2
        let targetHeight = targetWidth / aspectRatio
        return targetHeight + 20
    }
    
}
