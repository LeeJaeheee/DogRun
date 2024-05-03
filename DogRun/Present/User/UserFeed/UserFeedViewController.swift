//
//  UserFeedViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/27/24.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class UserFeedViewController: UIViewController {
    
    let tableView = UITableView()
    
    private lazy var viewSpinner: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100)
        )
        let spinner = UIActivityIndicatorView()
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    let disposeBag = DisposeBag()
    
    let viewModel = UserFeedViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        
        bind()
    }
    
    private func bind() {
        var changedLikeId: [Int: Void] = [:]
        
        let input = UserFeedViewModel.Input(
            loadTrigger: BehaviorRelay(value: ()),
            fetchMoreDatas: tableView.rx.prefetchRows
        )
        
        let output = viewModel.transform(input: input)
        
        output.posts
            .drive(tableView.rx.items(cellIdentifier: FeedTableViewCell.identifier, cellType: FeedTableViewCell.self)) { index, post, cell in
                cell.configureData(data: post)
                cell.likeButton.rx.tap
                    .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
                    .flatMap { _ in
                        print(post.post_id)
                        print(!post.likes.contains(UserDefaultsManager.userId))
                        return NetworkManager.request2(type: LikeModel.self, router: LikeRouter.like(postId: post.post_id, model: .init(like_status: !post.likes.contains(UserDefaultsManager.userId))))
                    }
                    .bind(with: self, onNext: { owner, response in
                        switch response {
                        case .success(let success):
                            cell.likeButton.tintColor = success.like_status ? .systemRed : .white
                            if let _ = changedLikeId[index] {
                                changedLikeId.removeValue(forKey: index)
                            } else {
                                changedLikeId[index] = ()
                            }
                        case .failure(let failure):
                            owner.errorHandler(failure)
                        }
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.commentButton.rx.tap
                    .bind(with: self) { owner, _ in
                        let vc = CommentViewController()
                        vc.viewModel.postId = post.post_id
                        vc.viewModel.comments.accept(post.comments)
                        owner.present(vc, animated: true)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.tapImageCardSubject
                    .bind(with: self, onNext: { owner, imageIndex in
                        print("\(imageIndex) in cell: \(index)")
                        
                        if let files = post.files {
                            owner.showImageFullscreen(files[imageIndex], index: imageIndex)
                        }
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.fetchFailure
            .bind(with: self) { owner, error in
                owner.errorHandler(error)
            }
            .disposed(by: disposeBag)
        
    }

}


extension UserFeedViewController {
    func showImageFullscreen(_ imageURL: String, index: Int) {
        let fullscreenVC = PostDetailViewController()
        fullscreenVC.index = index
        fullscreenVC.modalPresentationStyle = .fullScreen
        
        // TODO: 프레임 계산 다시하기
        let startingFrame = CGRect(x: UIScreen.main.bounds.width/6, y: UIScreen.main.bounds.height/6, width: 200, height: 300)
        let finalFrame = UIScreen.main.bounds
        
        let transitionImageView = UIImageView(frame: startingFrame)
        transitionImageView.kf.setImage(with: URL(string: APIKey.baseURL.rawValue+"/"+imageURL))
        transitionImageView.contentMode = .scaleAspectFill
        transitionImageView.clipsToBounds = true
        transitionImageView.layer.cornerRadius = 20
        view.addSubview(transitionImageView)
        
        UIView.animate(withDuration: 0.7, animations: {
            transitionImageView.frame = finalFrame
            transitionImageView.layer.cornerRadius = 0
        }) { (finished) in
            transitionImageView.removeFromSuperview()
            self.present(fullscreenVC, animated: false)
        }
    }
}


