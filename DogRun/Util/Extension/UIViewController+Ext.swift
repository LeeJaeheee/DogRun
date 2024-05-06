//
//  UIViewController+Ext.swift
//  DogRun
//
//  Created by 이재희 on 4/27/24.
//

import UIKit
import Toast
import MapKit
import Kingfisher

extension UIViewController {
    
    func changeRootView(to viewController: UIViewController, isNav: Bool = false) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let sceneDelegate = windowScene.delegate as? SceneDelegate
        let vc = isNav ? UINavigationController(rootViewController: viewController) : viewController
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKey()
    }
    
    func showToast(_ message: String, position: ToastPosition) {
        var style = ToastStyle()
        style.horizontalPadding = 30
        style.verticalPadding = 20
        style.messageFont = .systemFont(ofSize: 18)
        view.makeToast(message, position: position, style: style)
    }
    
    func showAlert(title: String? = nil, message: String? = nil, style: UIAlertController.Style = .alert, okTitle: String = "확인", okStyle: UIAlertAction.Style = .default, showCancelButton: Bool = false, handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: okTitle, style: okStyle) { _ in
            handler?()
        }
        alert.addAction(okAction)
        if showCancelButton {
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        }
        present(alert, animated: true)
    }
    
    func showAlertForDismiss() {
        showAlert(style: .actionSheet, okTitle: "변경사항 폐기", okStyle: .destructive, showCancelButton: true) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showDeleteAlert(title: String, message: String, handler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let delete = UIAlertAction(title: "삭제", style: .destructive, handler: handler)
        
        alert.addAction(cancel)
        alert.addAction(delete)
        
        present(alert, animated: true)
    }
    
    
    func captureMapSnapshot(mapView: MKMapView, completionHandler: @escaping (UIImage?) -> Void) {
        let options = MKMapSnapshotter.Options()
        options.mapType = mapView.mapType
        //options.mapRect = mapView.visibleMapRect
        options.region = mapView.region
        options.size = mapView.frame.size
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print(error?.localizedDescription ?? "맵 스냅샷 에러")
                completionHandler(nil)
                return
            }
            UIGraphicsBeginImageContextWithOptions(snapshot.image.size, true, snapshot.image.scale)
            
            // 스냅샷 이미지 그리기
            snapshot.image.draw(at: CGPoint.zero)
            
            // TODO: 오버레이 그리기
            for overlay in mapView.overlays {
                if let polyline = overlay as? MKPolyline {
                    let path = UIBezierPath()
                    var firstPoint: Bool = true
                    
                    for i in 0..<polyline.pointCount {
                        let mapPoint = polyline.points()[i]
                        let cgPoint = snapshot.point(for: mapPoint.coordinate)
                        
                        if firstPoint {
                            path.move(to: cgPoint)
                            firstPoint = false
                        } else {
                            path.addLine(to: cgPoint)
                        }
                    }
                    
                    UIColor.systemYellow.setStroke()
                    path.lineWidth = 12.0
                    path.stroke()
                }
            }
            
            // 어노테이션 그리기
            for annotation in mapView.annotations {
                
                let point = snapshot.point(for: annotation.coordinate)
                
                // 현재 위치 어노테이션은 CustomAnnotation이 아니므로 continue로 넘겨주기
                guard let customAnnotation = annotation as? CustomAnnotation else { continue }
                
                let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
                backgroundView.backgroundColor = .white
                backgroundView.layer.cornerRadius = 8
                
                let imageView = UIImageView(image: customAnnotation.image)
                imageView.tintColor = customAnnotation.tintColor
                imageView.frame = CGRect(x: 4, y: 4, width: 28, height: 28)
                backgroundView.addSubview(imageView)

                backgroundView.asImage().draw(at: .init(x: point.x-18, y: point.y-44))
            }
            
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            completionHandler(finalImage)
        }

    }
    
    func errorHandler(_ error: DRError, completionHandler: @escaping (() -> Void) = { }) {
        
        if error.isCommon {
            
        }
        
        switch error.handlingRule {
            
        case .showToast:
            showToast(error.errorMessage, position: .center)
        case .showLogin:
            showAlert(title: "🔒", message: "\n로그인이 필요한 서비스입니다.\n로그인 후 다시 시도해주세요!\n", okTitle: "로그인하러 가기") { [weak self] in
                let nav = UINavigationController(rootViewController: EmailViewController(mode: .modify))
                nav.modalPresentationStyle = .fullScreen
                self?.present(nav, animated: true, completion: nil)
            }
        case .developerFaultSorry:
            showAlert(title: "오류 발생", message: "\n\(error.errorMessage)\n개발자에게 돌을 던져주세요...🪨")
        case .internetInvalid:
            let errorVC = NetworkErrorPopUpViewController()
            errorVC.errorType = error
            errorVC.modalPresentationStyle = .overFullScreen
            self.present(errorVC, animated: false, completion: nil)
        }
        
    }
    

}

extension UIViewController {
    
    func preloadImages(urlStrings: [String], completion: @escaping ([Int: (CGSize, UIImage?)]) -> Void) {
        var imageInfo: [Int: (CGSize, UIImage?)] = [:]
        let group = DispatchGroup()
        
        for (index, urlString) in urlStrings.enumerated() {
            if let url = URL(string: APIKey.baseURL.rawValue + "/" + urlString) {
                group.enter()
                KingfisherManager.shared.retrieveImage(with: url) { result in
                    switch result {
                    case .success(let value):
                        imageInfo[index] = (value.image.size, value.image)
                    case .failure:
                        imageInfo[index] = (CGSize(width: 100, height: 100), nil)
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(imageInfo)
        }
    }
    
}
