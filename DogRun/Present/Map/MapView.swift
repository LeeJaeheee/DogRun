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
    
    override func configureHierarchy() {
        [mapView, startButton].forEach { addSubview($0) }
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
    }
    
    override func configureView() {
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.isZoomEnabled = true
        mapView.delegate = self
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
