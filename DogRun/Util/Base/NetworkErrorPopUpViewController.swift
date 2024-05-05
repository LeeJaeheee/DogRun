//
//  InternetInvalidPopUpViewController.swift
//  DogRun
//
//  Created by 이재희 on 5/5/24.
//

import UIKit
import Lottie

class NetworkErrorPopUpViewController: UIViewController {
    
    private let containerView = UIView()

    private let titleLabel = UILabel()
    private let animationView = LottieAnimationView()
    private let detailLabel = UILabel()
    private let button = UIButton()
    
    var errorType: DRError = .internetInvalid(message: "네트워크 연결 상태를 확인해주세요.")

    override func viewDidLoad() {
        super.viewDidLoad()
        print("444444")

        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = true
        }
    }
    
    private func configureHierarchy() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(animationView)
        containerView.addSubview(detailLabel)
        containerView.addSubview(button)
    }
    
    private func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
        }
        
        animationView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(animationView.snp.width).multipliedBy(1)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .black.withAlphaComponent(0.2)
        modalPresentationStyle = .overFullScreen
        
        containerView.backgroundColor = UIColor(white: 1, alpha: 0.92)
        containerView.layer.cornerRadius = 18
        containerView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        titleLabel.text = "네트워크 오류"
        titleLabel.textAlignment = .center
        
        detailLabel.numberOfLines = 0
        detailLabel.text = errorType.errorMessage
        detailLabel.font = .systemFont(ofSize: 13, weight: .light)
        detailLabel.textAlignment = .center
        
        animationView.animation = LottieAnimation.named("networkerror")
        animationView.play()
        
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .accent
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        self.dismiss(animated: false)
    }

}
