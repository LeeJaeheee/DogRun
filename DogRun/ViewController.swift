//
//  ViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/18/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let textField = DRTextField(title: "이메일")
    let button = DRButton(title: "다음")
    let titleLabel = DRLabel(text: "이메일을 입력해주세요", style: .title)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(70)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(textField.basicHeight)
        }
        textField.isValid = false
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(60)
            make.height.equalTo(48)
        }

    }


}

