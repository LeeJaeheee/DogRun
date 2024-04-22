//
//  MapViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/22/24.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import CoreMotion
import MapKit

final class MapViewController: BaseViewController<MapView> {
    
    private let viewModel = MapViewModel()
    
    var trackData: TrackData = TrackData(traces: [])
    let motionManager = CMMotionActivityManager()
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.distanceFilter = 10
        manager.allowsBackgroundLocationUpdates = true
        //manager.pausesLocationUpdatesAutomatically = true
        //manager.startUpdatingLocation()
        manager.delegate = self
        return manager
     }()
    
    var previousCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLocationUsagePermission()
    }
    
    override func bind() {
        
    }
    
    func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.locationManager.stopUpdatingLocation()
    }
    
    // TODO: 아래 코드들(테스트용) 뷰 그리고 수정하기
    
    @objc func touchUpShowCurrentLocation(_ sender: Any) {
        mainView.mapView.showsUserLocation = true
        mainView.mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    @objc func touchUpTrackStopButton(_ sender: Any) {
        self.locationManager.stopUpdatingLocation()
    }
    
    @objc func startButtonTapped(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                print("GPS 권한 설정됨")
            case .restricted, .notDetermined:
                print("GPS 권한 설정되지 않음")
                DispatchQueue.main.async {
                    self.getLocationUsagePermission()
                }
            case .denied:
                print("GPS 권한 요청 거부됨")
                DispatchQueue.main.async {
                    self.getLocationUsagePermission()
                }
            default:
                print("GPS: Default")
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        

        guard let location = locations.last
        else {return}
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        if let previousCoordinate = self.previousCoordinate {
            var points: [CLLocationCoordinate2D] = []
            let point1 = CLLocationCoordinate2DMake(previousCoordinate.latitude, previousCoordinate.longitude)
            let point2: CLLocationCoordinate2D
            = CLLocationCoordinate2DMake(latitude, longitude)
            points.append(point1)
            points.append(point2)
            let lineDraw = MKPolyline(coordinates: points, count:points.count)
            mainView.mapView.addOverlay(lineDraw)
        }
        
        self.previousCoordinate = location.coordinate
        
        let newTrace = Trace(latitude: latitude, longitude: longitude)
        self.trackData.appendTrace(trace: newTrace)
    }
}