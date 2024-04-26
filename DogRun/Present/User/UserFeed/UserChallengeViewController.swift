//
//  UserChallengeViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/27/24.
//

import UIKit
import RxSwift
import RxCocoa

class UserChallengeViewController: UIViewController {
    
    let tableView = UITableView()
    
    let data = Observable.just([1,2,3,4,5,6])
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.register(UserChallengeTableViewCell.self, forCellReuseIdentifier: UserChallengeTableViewCell.identifier)

        data.bind(to: tableView.rx.items(cellIdentifier: UserChallengeTableViewCell.identifier, cellType: UserChallengeTableViewCell.self)) { index, item, cell in
            cell.mainImageView.backgroundColor = .init(red: CGFloat.random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
            cell.titleLabel.text = "\(item)번 타이틀"
            cell.button.setTitle("인증하기", for: .normal)
        }
        .disposed(by: disposeBag)
    }

}
