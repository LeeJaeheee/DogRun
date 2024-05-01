//
//  BasePopUpView.swift
//  DogRun
//
//  Created by 이재희 on 5/1/24.
//

import UIKit

class BasePopUpView: UIView {
    
    let containerView = UIView()
    let okButton = DRVariableButton(title: "확인", style: .filled)
    let cancelButton = DRVariableButton(title: "취소", style: .outlined)
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureBaseView()
        
        configureHierarchy()
        configureLayout()
        configureView()
        configureData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureBaseView() {
        backgroundColor = .black.withAlphaComponent(0.2)
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(32)
            make.verticalEdges.equalToSuperview().inset(120)
        }
        containerView.clipsToBounds = true
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 18
        containerView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        containerView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(containerView.snp.centerX).offset(-4)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().inset(20)
        }
        
        containerView.addSubview(okButton)
        okButton.snp.makeConstraints { make in
            make.leading.equalTo(cancelButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().inset(20)
        }

    }
    
    func configureHierarchy() { }
    func configureLayout() { }
    func configureView() { }
    func configureData() { }
    
}
