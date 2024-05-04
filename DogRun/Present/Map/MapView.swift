//
//  MapView.swift
//  DogRun
//
//  Created by 이재희 on 4/22/24.
//

import UIKit
import MapKit
import SnapKit

final class MapView: BaseView {
    
    let mapView = MKMapView()
    let dimView = UIView()
    let titleLabel = DRLabel(text: "오늘도\n달려볼까요?🐶", style: .largeTitle)
    let startButton = DRButton(title: "산책 시작")
    
    let heartButton = DRRoundImageButton(buttonImage: .heart)
    let numOneButton = DRRoundImageButton(buttonImage: .numOne)
    let numTwoButton = DRRoundImageButton(buttonImage: .numTwo)
    
    let currentLocationButton = UIButton()
    let stopButton = DRRoundImageButton(imageName: "stop.fill", tintColor: .black, backgroundWhite: 1.0, alpha: 1.0)
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [heartButton, numOneButton, numTwoButton])
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    override func configureHierarchy() {
        [mapView, dimView, titleLabel, startButton, buttonsStackView, currentLocationButton, stopButton].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        dimView.snp.makeConstraints { make in
            make.edges.equalTo(mapView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(40)
            make.top.equalTo(safeAreaLayoutGuide).inset(80)
        }

        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(40)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(70)
            make.height.equalTo(startButton.basicHeight)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
        
        heartButton.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
        
        numOneButton.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
        
        numTwoButton.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.centerX.equalTo(buttonsStackView)
            make.top.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(48)
        }
        
        stopButton.snp.makeConstraints { make in
            make.centerX.equalTo(buttonsStackView)
            make.centerY.equalTo(startButton)
            make.size.equalTo(48)
        }
    }
    
    override func configureView() {
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.isZoomEnabled = true
        
        dimView.backgroundColor = .init(white: 1.0, alpha: 0.75)
        
        currentLocationButton.setImage(UIImage(systemName: "dot.circle.viewfinder", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
        currentLocationButton.tintColor = .systemBlue
        
        [currentLocationButton, buttonsStackView, stopButton].forEach { $0.isHidden = true }
    }
    
    func toggleHidden() {
        [currentLocationButton, buttonsStackView, stopButton, dimView, titleLabel, startButton].forEach { $0.isHidden.toggle() }
    }
}

