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
import PhotosUI

class UserProfileViewController: UIViewController {
    
    var viewModel = UserProfileViewModel()
    
    let headerView = UserProfileHeaderView()
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let withdrawButton = UIButton()
    
    let disposeBag = DisposeBag()
    
    let updateTrigger = PublishRelay<ProfileResponse>()
    let profileUpdated = PublishRelay<Data>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupTableView()
        bindViewModel()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        view.addSubview(withdrawButton)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        withdrawButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.centerX.equalToSuperview()
        }
        
        tableView.register(UserProfileTableViewCell.self, forCellReuseIdentifier: UserProfileTableViewCell.identifier)
        tableView.tableHeaderView = headerView
        tableView.rowHeight = UITableView.automaticDimension
        
        withdrawButton.setTitle("회원 탈퇴", for: .normal)
        withdrawButton.titleLabel?.font = .systemFont(ofSize: 13)
        withdrawButton.setTitleColor(.systemRed, for: .normal)
    }

    private func bindViewModel() {
        
        let withdraw = PublishRelay<Void>()
        
        let input = UserProfileViewModel.Input(
            loadTrigger: BehaviorRelay<Void>(value: ()), 
            updateTrigger: updateTrigger,
            itemSelected: tableView.rx.itemSelected.asObservable(), 
            profileUpdated: profileUpdated, 
            withdrawButtonTap: withdrawButton.rx.tap, 
            withdraw: withdraw
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
                            self?.updateTrigger.accept($0)
                        }
                        self?.navigationController?.pushViewController(detailVC, animated: true)
                    case .phoneNumber:
                        let detailVC = PhoneNumberViewController(mode: .modify)
                        detailVC.phoneNumber = item.content ?? ""
                        detailVC.popAction = {
                            self?.updateTrigger.accept($0)
                        }
                        self?.navigationController?.pushViewController(detailVC, animated: true)
                    case .birthdate:
                        let detailVC = BirthdayViewController(mode: .modify)
                        detailVC.viewModel.phoneNumber = item.content ?? ""
                        detailVC.popAction = {
                            self?.updateTrigger.accept($0)
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
        
        headerView.profileImageButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.presentImagePicker()
            }
            .disposed(by: disposeBag)
        
        output.profileUpdateSuccess
            .bind(with: self) { owner, response in
                owner.headerView.configureData(data: response)
            }
            .disposed(by: disposeBag)
        
        output.profileUpdateFailure
            .bind(with: self) { owner, error in
                owner.errorHandler(error)
            }
            .disposed(by: disposeBag)
        
        output.confirmWithdraw
            .drive(with: self) { owner, _ in
                owner.showDeleteAlert(title: "회원 탈퇴", message: "\n정말 탈퇴하시겠습니까?\n") { _ in
                    withdraw.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        output.withdrawSuccess
            .bind(with: self) { owner, _ in
                owner.changeRootView(to: WelcomeViewController())
            }
            .disposed(by: disposeBag)
        
        output.withdrawFailure
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

extension UserProfileViewController {
    private func presentImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension UserProfileViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        processPickedImages(results: results)
    }
    
    private func processPickedImages(results: [PHPickerResult]) {
        for result in results {
            let itemProvider = result.itemProvider
            guard itemProvider.canLoadObject(ofClass: UIImage.self) else { continue }
            
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        let data = image.resizedImage(below: 5, compressionQuality: 0.5)
                        self?.profileUpdated.accept(data ?? Data())
                    }
                }
            }
        }
    }
    
}
