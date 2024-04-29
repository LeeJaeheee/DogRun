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
            self.dismiss(animated: true)
        }
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
            showAlert(title: "오류 발생", message: "\n개발자에게 돌을 던져주세요...🪨")
        }
        
    }
    

}
