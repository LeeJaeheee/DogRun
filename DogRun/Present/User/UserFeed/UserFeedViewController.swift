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
    
    var files = Observable.just(Array(repeating: ["https://picsum.photos/200", "https://picsum.photos/300", "https://picsum.photos/200", "https://picsum.photos/200", "https://picsum.photos/200"], count: 10))
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        files.bind(to: tableView.rx.items(cellIdentifier: FeedTableViewCell.identifier, cellType: FeedTableViewCell.self)) { index, files, cell in
            cell.configureImages(with: files)
            cell.tapImageCardSubject
                .bind(with: self, onNext: { owner, imageIndex in
                    print("\(imageIndex) in cell: \(index)")
                    //TODO: 디테일 페이지 연결
                    owner.showImageFullscreen(files[index], index: imageIndex)
                })
                .disposed(by: cell.disposeBag)
        }
        .disposed(by: disposeBag)
    }

}

extension UserFeedViewController {
    func showImageFullscreen(_ imageURL: String?, index: Int) {
        let fullscreenVC = PostDetailViewController()
        fullscreenVC.index = index
        fullscreenVC.modalPresentationStyle = .fullScreen
        
        // TODO: 프레임 계산 다시하기
        let startingFrame = CGRect(x: UIScreen.main.bounds.width/6, y: UIScreen.main.bounds.height/6, width: 200, height: 300)
        let finalFrame = UIScreen.main.bounds
        
        let transitionImageView = UIImageView(frame: startingFrame)
        transitionImageView.kf.setImage(with: URL(string: imageURL!))
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


