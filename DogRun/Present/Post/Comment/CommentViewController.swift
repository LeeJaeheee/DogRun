//
//  CommentViewController.swift
//  DogRun
//
//  Created by 이재희 on 5/2/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CommentViewController: BaseViewController<CommentView> {
    let viewModel = CommentViewModel()
    
    override func bind() {
        let deleteButtonTap = PublishRelay<Int>()
        
        let input = CommentViewModel.Input(
            textInput: mainView.textView.rx.text,
            sendButtonTap: mainView.sendButton.rx.tap, deleteButtonTap: deleteButtonTap
        )
        
        let output = viewModel.transform(input: input)
        
        output.comments
            .drive(mainView.tableView.rx.items(cellIdentifier: CommentTableViewCell.identifier, cellType: CommentTableViewCell.self)) { index, comment, cell in
                cell.configureData(data: comment)
                cell.deleteButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.showDeleteAlert(title: "🗑️", message: "\n댓글을 정말 삭제하시겠습니까?\n") { _ in
                            deleteButtonTap.accept(index)
                        }
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.isTextEmpty
            .drive(with: self, onNext: { owner, value in
                owner.mainView.sendButton.isEnabled = !value
            })
            .disposed(by: disposeBag)
        
        output.commentSuccess
            .bind(with: self) { owner, _ in
                owner.mainView.endEditing(true)
                owner.mainView.textView.text = nil
            }
            .disposed(by: disposeBag)
        
        output.commentFailure
            .bind(with: self) { owner, error in
                owner.errorHandler(error)
            }
            .disposed(by: disposeBag)
        
        output.deleteSuccess
            .bind(with: self) { owner, _ in
                owner.showToast("댓글 삭제 완료", position: .center)
            }
            .disposed(by: disposeBag)
        
        output.deleteFailure
            .bind(with: self) { owner, error in
                owner.errorHandler(error)
            }
            .disposed(by: disposeBag)
        
    }
}
