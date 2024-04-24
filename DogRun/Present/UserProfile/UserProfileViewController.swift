//
//  UserProfileViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/24/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

class UserProfileViewController: UIViewController {
    
    var viewModel: UserProfileViewModel!
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupTableView()
        bindViewModel()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.register(UserProfileTableViewCell.self, forCellReuseIdentifier: UserProfileTableViewCell.identifier)
        
        // TODO: 동적으로 height 잡기
        let headerView = UserProfileHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        headerView.configureData(image: UIImage(systemName: "person")!, email: "aaa@aaa.com", sinceBirthDate: "태어난지 +364일🐾")
        tableView.tableHeaderView = headerView
        
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func bindViewModel() {
        viewModel = UserProfileViewModel()
        
        let input = UserProfileViewModel.Input(
            itemSelected: tableView.rx.itemSelected.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .bind(to: tableView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
        
        output.navigateToDetail
            .subscribe(onNext: { [weak self] item in
                let detailVC = UIViewController()
                detailVC.view.backgroundColor = .white
                detailVC.title = item.title
                self?.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func dataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<ProfileItem>> {
        return RxTableViewSectionedReloadDataSource<SectionModel<ProfileItem>>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileTableViewCell.identifier, for: indexPath) as! UserProfileTableViewCell
                cell.titleLabel.text = item.title
                cell.contentLabel.text = item.content
                cell.selectionStyle = .none
                cell.accessoryType = .disclosureIndicator
                return cell
            }, titleForHeaderInSection: { dataSource, index in
                return dataSource.sectionModels[index].header
            })
    }
}
