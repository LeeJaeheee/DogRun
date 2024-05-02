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
        let input = CommentViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        output.comments
            .drive(mainView.tableView.rx.items(cellIdentifier: CommentTableViewCell.identifier, cellType: CommentTableViewCell.self)) { index, comment, cell in
                cell.configureData(data: comment)
            }
            .disposed(by: disposeBag)
        
        mainView.textView.rx.didChange
            .bind(with: self) { owner, _ in
                let size = CGSize(width: owner.mainView.textView.frame.width, height: .infinity)
                let estimatedSize = owner.mainView.textView.sizeThatFits(size)
                let isMaxHeight = estimatedSize.height >= 85
                
                guard isMaxHeight != owner.mainView.textView.isScrollEnabled else { return }
                owner.mainView.textView.isScrollEnabled = isMaxHeight
                owner.mainView.textView.reloadInputViews()
                owner.mainView.setNeedsUpdateConstraints()
            }
            .disposed(by: disposeBag)
    }
}
