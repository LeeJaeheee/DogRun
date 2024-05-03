//
//  BaseTableViewCell.swift
//  DogRun
//
//  Created by 이재희 on 5/2/24.
//

import UIKit
import RxSwift

class BaseTableViewCell: UITableViewCell {
    
    let disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() { }
    func configureLayout() { }
    func configureView() { }
    
}
