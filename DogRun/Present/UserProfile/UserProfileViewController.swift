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
    
    var viewModel = UserProfileViewModel()
    
    let headerView = UserProfileHeaderView()
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
 
        tableView.tableHeaderView = headerView
        
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func bindViewModel() {
        let updateTrigger = PublishRelay<ProfileResponse>()
        
        let input = UserProfileViewModel.Input(
            loadTrigger: BehaviorRelay<Void>(value: ()), 
            updateTrigger: updateTrigger,
            itemSelected: tableView.rx.itemSelected.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .bind(to: tableView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
        
        output.navigateToDetail
            .subscribe(onNext: { [weak self] item in
                switch ProfileTitle(rawValue: item.title) {
                case .none:
                    break
                case .some(let value):
                    switch value {
                    case .nickname:
                        let detailVC = NicknameViewController(mode: .modify)
                        detailVC.nickname = item.content ?? ""
                        detailVC.popAction = {
                            updateTrigger.accept($0)
                        }
                        self?.navigationController?.pushViewController(detailVC, animated: true)
                    case .phoneNumber:
                        let detailVC = PhoneNumberViewController(mode: .modify)
                        detailVC.phoneNumber = item.content ?? ""
                        detailVC.popAction = {
                            updateTrigger.accept($0)
                        }
                        self?.navigationController?.pushViewController(detailVC, animated: true)
                    case .birthdate:
                        let detailVC = BirthdayViewController(mode: .modify)
                        detailVC.viewModel.phoneNumber = item.content ?? ""
                        detailVC.popAction = {
                            updateTrigger.accept($0)
                        }
                        self?.navigationController?.pushViewController(detailVC, animated: true)
                    }
                }
                
            })
            .disposed(by: disposeBag)
        
        output.fetchSuccess
            .bind(with: self) { owner, response in
                owner.headerView.configureData(data: response)
                
                owner.headerView.layoutIfNeeded()
                let height = owner.headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
                owner.headerView.frame.size.height = height
            }
            .disposed(by: disposeBag)
        
        output.fetchFailure
            .bind(with: self) { owner, error in
                owner.errorHandler(error)
            }
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
