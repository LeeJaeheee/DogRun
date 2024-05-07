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
    
    let viewModel = UserChallengeViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.separatorStyle = .none
        tableView.register(UserChallengeTableViewCell.self, forCellReuseIdentifier: UserChallengeTableViewCell.identifier)
        
        bind()
    }
    
    private func bind() {
        let input = UserChallengeViewModel.Input(loadTrigger: .init(value: ()))
        
        let output = viewModel.transform(input: input)
        
        output.paymentsList
            .bind(to: tableView.rx.items(cellIdentifier: UserChallengeTableViewCell.identifier, cellType: UserChallengeTableViewCell.self)) { index, item, cell in
                cell.titleLabel.text = item.productName
            }
            .disposed(by: disposeBag)
        
        output.fetchFailure
            .bind(with: self) { owner, error in
                owner.errorHandler(error)
            }
            .disposed(by: disposeBag)
    }

}
