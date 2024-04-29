//
//  UIViewController+Ext.swift
//  DogRun
//
//  Created by 이재희 on 4/27/24.
//

import UIKit
import Toast
import MapKit

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
    
    func captureMapSnapshot(mapView: MKMapView, completionHandler: @escaping (UIImage?) -> Void) {
        let options = MKMapSnapshotter.Options()
        options.mapType = mapView.mapType
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
            
            // TODO: 오버레이 그리기
            
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            completionHandler(finalImage)
        }

    }

}
