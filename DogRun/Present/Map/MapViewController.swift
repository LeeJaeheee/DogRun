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
    
    var isWalkingEnded = false
    
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
        
        mainView.startButton.addTarget(self, action: #selector(startWalk), for: .touchUpInside)
        mainView.stopButton.addTarget(self, action: #selector(endWalk), for: .touchUpInside)
        
        mainView.heartButton.addTarget(self, action: #selector(heartButtonTapped(_:)), for: .touchUpInside)
        mainView.numOneButton.addTarget(self, action: #selector(numOneButtonTapped(_:)), for: .touchUpInside)
        mainView.numTwoButton.addTarget(self, action: #selector(numTwoButtonTapped(_:)), for: .touchUpInside)
        mainView.currentLocationButton.addTarget(self, action: #selector(touchUpShowCurrentLocation), for: .touchUpInside)
        
        //mainView.startButton.addTarget(self, action: #selector(convertViewToImage), for: .touchUpInside)
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
    
    @objc func startWalk() {
        walkStartTime = Date()
        locationManager.startUpdatingLocation()
        mainView.toggleHidden()
    }
    
    @objc func endWalk() {
        
        showAlert(message: "산책을 종료하시겠습니까?", okTitle: "종료", showCancelButton: true) { [weak self] in
            guard let self else { return }
            
            locationManager.stopUpdatingLocation()
            mainView.toggleHidden()
            
            var minLatitude = CLLocationDegrees(90)
            var maxLatitude = CLLocationDegrees(-90)
            var minLongitude = CLLocationDegrees(180)
            var maxLongitude = CLLocationDegrees(-180)
            
            for trace in trackData.traces {
                minLatitude = min(minLatitude, trace.latitude)
                maxLatitude = max(maxLatitude, trace.latitude)
                minLongitude = min(minLongitude, trace.longitude)
                maxLongitude = max(maxLongitude, trace.longitude)
            }
            
            let centerLatitude = (minLatitude + maxLatitude) / 2
            let centerLongitude = (minLongitude + maxLongitude) / 2
            let centerCoordinate = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)

            let latitudeDelta = maxLatitude - minLatitude
            let longitudeDelta = maxLongitude - minLongitude
            let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
            
            let padding = 0.1
            let latitudeDeltaWithPadding = latitudeDelta * (1 + padding)
            let longitudeDeltaWithPadding = longitudeDelta * (1 + padding)
            let paddedSpan = MKCoordinateSpan(latitudeDelta: latitudeDeltaWithPadding, longitudeDelta: longitudeDeltaWithPadding)

            let paddedRegion = MKCoordinateRegion(center: centerCoordinate, span: paddedSpan)
            isWalkingEnded = true
            mainView.mapView.setRegion(paddedRegion, animated: true)


            
//            let topLeftCoordinate = CLLocationCoordinate2D(latitude: maxLatitude, longitude: minLongitude)
//            let bottomRightCoordinate = CLLocationCoordinate2D(latitude: minLatitude, longitude: maxLongitude)
//            
//            let topLeftMapPoint = MKMapPoint(topLeftCoordinate)
//            let bottomRightMapPoint = MKMapPoint(bottomRightCoordinate)
//            
//            // 모든 좌표를 포함하는 MKMapRect 생성
//            let mapRect = MKMapRect(
//                x: min(topLeftMapPoint.x, bottomRightMapPoint.x),
//                y: min(topLeftMapPoint.y, bottomRightMapPoint.y),
//                width: abs(topLeftMapPoint.x - bottomRightMapPoint.x),
//                height: abs(topLeftMapPoint.y - bottomRightMapPoint.y))
//            
//            let padding: CGFloat = 20.0
//            let mapRectPadded = mapRect.insetBy(dx: -padding, dy: -padding)
//            
//            mainView.mapView.setVisibleMapRect(mapRectPadded, animated: true)
            

            guard let startTime = walkStartTime else {
                print("산책을 시작하지 않았습니다.")
                return
            }
            
            walkEndTime = Date()
            
            guard let endTime = walkEndTime else {
                print("산책 종료 시간을 기록하지 못했습니다.")
                return
            }
            

            
//            captureMapSnapshot(mapView: mainView.mapView) { [weak self] image in
//                guard let image else { return }
//                self?.mainView.testImageView.image = image
//            }
        }
        

    }
    
    @objc func convertViewToImage() {
        //mainView.testImageView.image = mainView.asImage()
        
    }
    
    private func addAnnotation(buttonImage: ButtonImages) {
        let annotation = CustomAnnotation(
            coordinate: mainView.mapView.userLocation.coordinate,
            image: UIImage(systemName: buttonImage.imageName), 
            imageName: buttonImage.imageName,
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
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if isWalkingEnded {
            isWalkingEnded = false
            
            captureMapSnapshot(mapView: mapView) { [weak self] image in
                guard let self else { return }
                guard let image else { return }
                
                guard let startTime = walkStartTime else {
                    print("산책을 시작하지 않았습니다.")
                    return
                }
                
                walkEndTime = Date()
                
                guard let endTime = walkEndTime else {
                    print("산책 종료 시간을 기록하지 못했습니다.")
                    return
                }
                
                let vc = MapRecordPopUpViewContoller()
                vc.mapRecord = .init(mapImage: image, time: DateFormatterManager.shared.formatTimeInterval(endTime.timeIntervalSince(startTime)) ?? "기록 실패", distance: NumberFormatterManager.shared.formatDistance(totalDistance))
                vc.dismissAction = { [weak self] record in
                    let nextVC = UploadPostViewController()
                    nextVC.mapRecord = record
                    self?.navigationController?.pushViewController(nextVC, animated: true)
                }

                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: false, completion: nil)
            }
        }
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

