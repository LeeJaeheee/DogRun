//
//  UserFeedViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/27/24.
//

import UIKit
import RxSwift
import RxCocoa

class UserFeedViewController: UIViewController {
    
    let tableView = UITableView()
    
    var files = Observable.just(Array(repeating: ["a", "b", "c", "d", "e"], count: 10))
    
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
        }
        .disposed(by: disposeBag)
    }

}
