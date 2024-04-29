//
//  CustomAnnotationView.swift
//  DogRun
//
//  Created by 이재희 on 4/29/24.
//

import Foundation
import MapKit
import SnapKit

final class CustomAnnotationView: MKAnnotationView {
    
    static let identifier = "CustomAnnotationView"
    private let imageView = UIImageView()
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let customAnnotation = newValue as? CustomAnnotation else { return }
            imageView.image = customAnnotation.image?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = customAnnotation.tintColor
            image = nil
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        centerOffset = CGPoint(x: 0, y: -self.frame.size.height/2-8)
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.4
        layer.masksToBounds = false
        clipsToBounds = false
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        imageView.contentMode = .scaleAspectFit
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
