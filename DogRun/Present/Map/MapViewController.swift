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
//import CoreMotion
import MapKit

final class MapViewController: BaseViewController<MapView> {
    
    private let viewModel = MapViewModel()
    
    var trackData: TrackData = TrackData(traces: [])
    //let motionManager = CMMotionActivityManager()
    
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
    
    var walkStartTime: Date?
    var walkEndTime: Date?
    
    var previousLocation: CLLocation?
    var totalDistance: CLLocationDistance = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.mapView.delegate = self
        
        getLocationUsagePermission()
    }
    
    override func bind() {
        
    }
    
    override func configureView() {
        mainView.heartButton.addTarget(self, action: #selector(heartButtonTapped(_:)), for: .touchUpInside)
        mainView.numOneButton.addTarget(self, action: #selector(numOneButtonTapped(_:)), for: .touchUpInside)
        mainView.numTwoButton.addTarget(self, action: #selector(numTwoButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func heartButtonTapped(_ sender: UIButton) {
        addAnnotation(buttonImage: .heart)
    }
    
    @objc func numOneButtonTapped(_ sender: UIButton) {
        addAnnotation(buttonImage: .numOne)
    }
    
    @objc func numTwoButtonTapped(_ sender: UIButton) {
        addAnnotation(buttonImage: .numTwo)
    }
    
    func startWalk() {
        walkStartTime = Date()
    }
    
    func endWalk() {
        guard let startTime = walkStartTime else {
            print("산책을 시작하지 않았습니다.")
            return
        }
        
        walkEndTime = Date()
        
        guard let endTime = walkEndTime else {
            print("산책 종료 시간을 기록하지 못했습니다.")
            return
        }
        
        let timeInterval = endTime.timeIntervalSince(startTime)
//        let timeFormatter = DateComponentsFormatter()
//        timeFormatter.unitsStyle = .short
//        timeFormatter.allowedUnits = [.hour, .minute, .second]
//        timeFormatter.zeroFormattingBehavior = .default
//        let formattedTime = timeFormatter.string(from: timeInterval)
        
        let timeFormatter = DateComponentsFormatter()
        timeFormatter.unitsStyle = .positional
        timeFormatter.allowedUnits = [.hour, .minute, .second]
        timeFormatter.zeroFormattingBehavior = .pad
        let formattedTime = timeFormatter.string(from: timeInterval)
        
        print("산책 시간: \(formattedTime ?? "기록 실패")")
        print("이동 거리: \(totalDistance) meters")
    }
    
    private func addAnnotation(buttonImage: ButtonImages) {
        let annotation = CustomAnnotation(
            coordinate: mainView.mapView.userLocation.coordinate,
            image: UIImage(systemName: buttonImage.imageName),
            tintColor: buttonImage.tintColor
        )
        mainView.mapView.addAnnotation(annotation)
    }
    
    func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.locationManager.stopUpdatingLocation()
//    }
    
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

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard let customAnnotation = annotation as? CustomAnnotation else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier)
        if annotationView == nil {
            annotationView = CustomAnnotationView(annotation: customAnnotation, reuseIdentifier: CustomAnnotationView.identifier)
        } else {
            annotationView?.annotation = customAnnotation
        }
        
        return annotationView

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
        
        guard let location = locations.last else { return }
        
        if let previousLocation = previousLocation {
            totalDistance += location.distance(from: previousLocation)
        }
        previousLocation = location
        
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
