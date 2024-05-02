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
        let input = CommentViewModel.Input(
            textInput: mainView.textView.rx.text,
            sendButtonTap: mainView.sendButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.comments
            .drive(mainView.tableView.rx.items(cellIdentifier: CommentTableViewCell.identifier, cellType: CommentTableViewCell.self)) { index, comment, cell in
                cell.configureData(data: comment)
            }
            .disposed(by: disposeBag)
        
        output.isTextEmpty
            .drive(mainView.sendButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.commentFailure
            .bind(with: self) { owner, error in
                owner.errorHandler(error)
            }
            .disposed(by: disposeBag)
        
    }
}
