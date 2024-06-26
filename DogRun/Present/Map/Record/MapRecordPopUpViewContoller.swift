//
//  MapRecordPopUpViewContoller.swift
//  DogRun
//
//  Created by 이재희 on 5/1/24.
//

import UIKit
import RxSwift
import RxCocoa

struct MapRecordModel {
    var mapImage: UIImage?
    var time: String
    var distance: String
}

final class MapRecordPopUpViewContoller: BasePopUpViewController<MapRecordPopUpView> {
    
    let viewModel = MapRecordViewModel()
    
    var mapRecord: MapRecordModel?
    var dismissAction: ((MapRecordModel) -> Void)?
    
    override func bind() {
        mainView.okButton.rx.tap
            .bind(with: self) { owner, _ in

                owner.dismiss(animated: false) {
                    if var record = owner.mapRecord {
                        record.mapImage = owner.mainView.captureView.asImage()
                        owner.dismissAction?(record)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        mainView.cancelButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        guard let mapRecord else { return }
        mainView.imageView.image = mapRecord.mapImage
        mainView.timeLabel.text = mapRecord.time
        mainView.distanceLabel.text = mapRecord.distance
    }
    
}
