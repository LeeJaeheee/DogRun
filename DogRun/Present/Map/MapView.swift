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
    
    let heartButton = UIButton()
    let numOneButton = UIButton()
    let numTwoButton = UIButton()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [heartButton, numOneButton, numTwoButton])
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    override func configureHierarchy() {
        [mapView, startButton, buttonsStackView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    }
    
    override func configureView() {
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.isZoomEnabled = true
        mapView.delegate = self
        
        heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        heartButton.tintColor = .systemRed
        heartButton.backgroundColor = .init(white: 0, alpha: 0.4)
        heartButton.layer.cornerRadius = 24
        
        numOneButton.setImage(UIImage(systemName: "drop.fill"), for: .normal)
        numOneButton.tintColor = .systemYellow
        numOneButton.backgroundColor = .init(white: 0, alpha: 0.4)
        numOneButton.layer.cornerRadius = 24
        
        numTwoButton.setImage(UIImage(systemName: "hands.sparkles.fill"), for: .normal)
        numTwoButton.tintColor = .systemOrange
        numTwoButton.backgroundColor = .init(white: 0, alpha: 0.4)
        numTwoButton.layer.cornerRadius = 24
    }
}

extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline
        else {
            print("can't draw polyline")
            return MKOverlayRenderer()
        }
        let renderer = MKPolylineRenderer(polyline: polyLine)
            renderer.strokeColor = .systemYellow
            renderer.lineWidth = 8.0
            renderer.alpha = 1.0
 
        return renderer
    }
}
