//
//  UploadPostViewController.swift
//  DogRun
//
//  Created by 이재희 on 5/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

class UploadPostViewController: ModeBaseViewController<UploadPostView> {
    
    let viewModel = UploadPostViewModel()
    var mapRecord: MapRecordModel?
    
    let doneButton = UIBarButtonItem(systemItem: .done)
    
    private var dataSource: UICollectionViewDiffableDataSource<UploadSectionType, UploadItem>!
    private lazy var sections: [UploadSectionType] = UploadSectionType.allCases
    
    var date = Date()
    var images: [UploadItem] = [.init(type: .image(UIImage(systemName: "plus.square.fill.on.square.fill")))]
    var content: UploadItem = .init(type: .text(""))
    
    override func bind() {
        let uploadedImageFiles = PublishRelay<[String]>()
        
        doneButton.rx.tap
            .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .flatMap { _ in
                var images = self.images.map { $0.image }
                images.removeFirst()
                images.append(self.mapRecord?.mapImage)
                let data = images.compactMap { $0?.resizedImage(below: 5, compressionQuality: 0.5)}
                return NetworkManager.requestMultipart(type: UploadFilesResponse.self, router: PostRouter.uploadFiles(model: .init(files: data)))
            }
            .bind(with: self, onNext: { owner, response in
                switch response {
                case .success(let success):
                    dump(success)
                    uploadedImageFiles.accept(success.files)
                case .failure(let failure):
                    owner.errorHandler(failure)
                }
            })
            .disposed(by: disposeBag)
        
        uploadedImageFiles
            .map { $0 }
            .flatMapLatest { [weak self] files in
                return NetworkManager.request2(type: PostResponse.self, router: PostRouter.uploadPost(model: .init(title: nil, content: self?.content.textContent, content1: self?.mapRecord?.time, content2: self?.mapRecord?.distance, content3: nil, content4: nil, content5: nil, product_id: "dr_sns", files: files)))
            }
            .bind(with: self, onNext: { owner, response in
                switch response {
                case .success(let success):
                    dump(success)
                    owner.navigationController?.popViewController(animated: true)
                case .failure(let failure):
                    owner.errorHandler(failure)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
        
        mainView.collectionView.delegate = self
        configureCollectionView()
        
        if let image = mapRecord?.mapImage {
            mainView.imageView.image = image
        }
        
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func cancelButtonTapped() {
        showAlertForDismiss()
    }
    
    func addImageButtonTapped() {
        guard images.count < 5 else {
            showToast("사진은 최대 4장까지만 선택이 가능해요!", position: .center)
            return
        }
        presentImagePicker()
    }
    
    private func presentImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5 - images.count
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    private func configureCollectionView() {
        configureDataSource()
        updateSnapshot()
    }



    private func configureDataSource() {
        let imageCellRegistration = imageCellRegistration()
        let dateLabelCellRegistration = labelCellRegistration()
        let textViewCellRegistration = textViewCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let section = self.sections[indexPath.section]
            switch section {
            case .date:
                return collectionView.dequeueConfiguredReusableCell(using: dateLabelCellRegistration, for: indexPath, item: itemIdentifier)
            case .image:
                return collectionView.dequeueConfiguredReusableCell(using: imageCellRegistration, for: indexPath, item: itemIdentifier)
            case .text:
                return collectionView.dequeueConfiguredReusableCell(using: textViewCellRegistration, for: indexPath, item: itemIdentifier)
            }
        })
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<UploadSectionType, UploadItem>()

        for section in sections {
            snapshot.appendSections([section])
            switch section {
            case .date:
                snapshot.appendItems([UploadItem(type: .date(date))], toSection: section)
            case .image:
                snapshot.appendItems(images, toSection: section)
            case .text:
                snapshot.appendItems([content], toSection: section)
            }
        }
        dataSource.apply(snapshot)
    }
    
}

extension UploadPostViewController: PHPickerViewControllerDelegate {
    
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
                        let item = UploadItem(type: .image(image))
                        self?.images.append(item)
                        self?.updateSnapshot()
                    }
                }
            }
        }
    }
    
}

extension UploadPostViewController {
    
    private func imageCellRegistration() -> UICollectionView.CellRegistration<ImageCollectionViewCell, UploadItem> {
        UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.configure(image: itemIdentifier.image!)
            cell.configureImageCell()
        }
    }
    
    private func labelCellRegistration() -> UICollectionView.CellRegistration<LabelCollectionViewCell, UploadItem> {
        UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.configure(text: itemIdentifier.dateText)
        }
    }
    
    private func textViewCellRegistration() -> UICollectionView.CellRegistration<TextViewCollectionViewCell, UploadItem> {
        UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.configureText(text: itemIdentifier.textContent)
            /*
            if self.pageType == .show {
                cell.textView.isEditable = false
                cell.textView.inputAccessoryView = nil
            }
             */
            cell.delegate = self
        }
    }
}

extension UploadPostViewController: TextViewCollectionViewCellDelegate {
    func textViewDidChangeInCell(text: String) {
        content.setTextContent(text)
        dataSource.apply(dataSource.snapshot(for: .text), to: .text, animatingDifferences: false)
    }
}

extension UploadPostViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            addImageButtonTapped()
        } else {
            showDeleteAlert(title: "삭제", message: "\n선택한 사진을 정말 삭제하시겠습니까?") { [weak self] _ in
                self?.images.remove(at: indexPath.item)
                self?.updateSnapshot()
            }
        }
    }
}



