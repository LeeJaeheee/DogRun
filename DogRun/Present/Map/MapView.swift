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
    let startButton = DRButton(title: "산책 시작")
    
    let heartButton = DRRoundImageButton(buttonImage: .heart)
    let numOneButton = DRRoundImageButton(buttonImage: .numOne)
    let numTwoButton = DRRoundImageButton(buttonImage: .numTwo)
    
    let currentLocationButton = UIButton()
    let stopButton = DRRoundImageButton(imageName: "stop.fill", tintColor: .black, backgroundWhite: 1.0, alpha: 1.0)
    
    let testImageView = UIImageView()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [heartButton, numOneButton, numTwoButton])
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    override func configureHierarchy() {
        [mapView, startButton, buttonsStackView, currentLocationButton, stopButton].forEach { addSubview($0) }
        
        addSubview(testImageView)
        testImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(500)
        }
        //testImageView.backgroundColor = .white
    }
    
    override func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
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
        
        currentLocationButton.setImage(UIImage(systemName: "dot.circle.viewfinder", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
        currentLocationButton.tintColor = .systemBlue
        
        [currentLocationButton, buttonsStackView, stopButton].forEach { $0.isHidden = true }
    }
    
    func toggleHidden() {
        [currentLocationButton, buttonsStackView, stopButton, startButton].forEach { $0.isHidden.toggle() }
    }
}

