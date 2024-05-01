//
//  MapRecordPopUpView.swift
//  DogRun
//
//  Created by 이재희 on 5/1/24.
//

import UIKit

final class MapRecordPopUpView: BasePopUpView {
    
    let captureView = UIView()
    let imageView = UIImageView()
    
    let labelContainerView = UIView()
    let timeTitleLabel = UILabel()
    let timeLabel = UILabel()
    let distanceTitleLabel = UILabel()
    let distanceLabel = UILabel()
    
    override func configureHierarchy() {
        containerView.addSubview(captureView)
        
        captureView.addSubview(imageView)
        captureView.addSubview(labelContainerView)
        
        [timeTitleLabel, timeLabel, distanceTitleLabel, distanceLabel].forEach { labelContainerView.addSubview($0) }
    }
    
    override func configureLayout() {
        captureView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(okButton.snp.top).offset(-20)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        labelContainerView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        timeTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(8)
            make.trailing.equalTo(labelContainerView.snp.centerX).offset(-2)
            make.height.equalTo(20)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(timeTitleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(8)
            make.trailing.equalTo(labelContainerView.snp.centerX).offset(-2)
            make.bottom.equalToSuperview().inset(12)
        }
        
        distanceTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(8)
            make.leading.equalTo(labelContainerView.snp.centerX).offset(2)
            make.height.equalTo(20)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceTitleLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview().inset(8)
            make.leading.equalTo(labelContainerView.snp.centerX).offset(2)
            make.bottom.equalToSuperview().inset(12)
        }
        
        cancelButton.snp.updateConstraints { make in
            make.trailing.equalTo(containerView.snp.centerX).offset(-52)
        }
        
    }
    
    override func configureView() {
        okButton.setTitle("피드 작성하러 가기", for: .normal)
        labelContainerView.backgroundColor = .init(white: 1.0, alpha: 0.8)
        labelContainerView.layer.cornerRadius = 12
        
        timeTitleLabel.text = "산책 시간"
        timeTitleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        distanceTitleLabel.text = "이동 거리"
        distanceTitleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        [timeTitleLabel, timeLabel, distanceTitleLabel, distanceLabel].forEach { $0.textAlignment = .center }
        
        imageView.backgroundColor = .blue
        
    }
    
}
