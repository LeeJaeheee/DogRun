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
    let refreshControl = UIRefreshControl()
    
    private lazy var viewSpinner: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100)
        )
        let spinner = UIActivityIndicatorView()
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        return view
    }()
    
    let disposeBag = DisposeBag()
    
    let viewModel = UserFeedViewModel()
    
    let loadTrigger = BehaviorRelay(value: ())

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.usertype != .specific {
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        }
        //loadTrigger.accept(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if viewModel.usertype != .specific {
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    private func bind() {
        var changedLikeId: [Int: Void] = [:]
        
        let input = UserFeedViewModel.Input(
            loadTrigger: loadTrigger,
            fetchMoreDatas: tableView.rx.willDisplayCell,
            refreshTrigger: refreshControl.rx.controlEvent(.valueChanged)
        )
        
        let output = viewModel.transform(input: input)
        
        output.posts
            .drive(tableView.rx.items(cellIdentifier: FeedTableViewCell.identifier, cellType: FeedTableViewCell.self)) { index, post, cell in
                cell.configureData(data: post)
                
                cell.likeButton.rx.tap
                    .debounce(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
                    .bind(with: self) { owner, _ in
                        owner.viewModel.tapLikeButton(post: post, index: index)
                    }
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
                        let cellFrameInSuperview = owner.tableView.convert(cell.frame, to: owner.tableView.superview)
                        
                        if let files = post.files {
                            owner.showImageFullscreen(files[imageIndex], post: post, index: imageIndex, cellFrame: cellFrameInSuperview)
                        }
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.profileView.tapGesture.rx.event
                    .debounce(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
                    .bind(with: self) { owner, _ in
                        let vc = UserViewController()
                        vc.viewModel.userId = post.creator.user_id
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.fetchFailure
            .bind(with: self) { owner, error in
                owner.errorHandler(error)
            }
            .disposed(by: disposeBag)
        
        output.isLoadingSpinnerAvaliable
            .bind(with: self, onNext: { owner, value in
                owner.tableView.refreshControl?.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        viewModel.failureRelay
            .bind(with: self) { owner, error in
                owner.errorHandler(error)
            }
            .disposed(by: disposeBag)
        
    }

}


extension UserFeedViewController {
    func showImageFullscreen(_ imageURL: String, post: PostResponse, index: Int, cellFrame: CGRect) {
        let fullscreenVC = PostDetailViewController()
        fullscreenVC.index = index
        fullscreenVC.post = post
        fullscreenVC.modalPresentationStyle = .fullScreen
        
        // TODO: 프레임 계산 다시하기
        let startingFrame = CGRect(x: 60, y: cellFrame.minY+60, width: cellFrame.width-80, height: cellFrame.height-80)
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


