//
//  FollowerViewController.swift
//  DogRun
//
//  Created by 이재희 on 5/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class FollowerViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let tableView = UITableView()
    
    let users = BehaviorRelay<[Follower]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureView()
        bind()
    }
    
    func bind() { 
        users
            .bind(to: tableView.rx.items(cellIdentifier: FollowerTableViewCell.identifier, cellType: FollowerTableViewCell.self)) { index, user, cell in
                cell.configureData(data: user)
            }
            .disposed(by: disposeBag)
    }
    
    func configureView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.register(FollowerTableViewCell.self, forCellReuseIdentifier: FollowerTableViewCell.identifier)
    }
    
}
