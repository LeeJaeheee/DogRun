//
//  CustomAnnotataion.swift
//  DogRun
//
//  Created by 이재희 on 4/29/24.
//

import UIKit
import MapKit

final class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var image: UIImage?
    var imageName: String?
    var tintColor: UIColor?

    init(coordinate: CLLocationCoordinate2D, image: UIImage?, imageName: String?, tintColor: UIColor? = .accent) {
        self.coordinate = coordinate
        self.image = image
        self.imageName = imageName
        self.tintColor = tintColor
        
        super.init()
    }
}
