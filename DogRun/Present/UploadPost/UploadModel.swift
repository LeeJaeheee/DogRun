//
//  UploadModel.swift
//  DogRun
//
//  Created by 이재희 on 5/1/24.
//

import UIKit

struct UploadItem: Hashable, Identifiable {
    enum ItemType: Hashable, Equatable {
        case date(Date)
        case image(UIImage?)
        case text(String)
    }

    var type: ItemType
    let id = UUID()

    var dateText: String? {
        guard case .date(let date) = type else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 EEEE"
        return ""
    }

    var image: UIImage? {
        guard case .image(let image) = type else { return nil }
        return image
    }

    var textContent: String {
        guard case .text(let content) = type else { return "" }
        return content
    }
    
    mutating func setTextContent(_ text: String) {
        self.type = .text(text)
    }

    init(type: ItemType) {
        self.type = type
    }
}

enum UploadSectionType: Int, CaseIterable {
    case date
    case image
    case text
    
    func createSection() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize
        let itemInset: NSDirectionalEdgeInsets?
        let orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior
        
        switch self {
        case .date:
            itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(52))
            itemInset = nil
            orthogonalScrollingBehavior = .none
        case .image:
            itemSize = NSCollectionLayoutSize(widthDimension: .absolute(88), heightDimension: .absolute(140))
            itemInset = NSDirectionalEdgeInsets(top: 40, leading: 8, bottom: 20, trailing: 0)
            orthogonalScrollingBehavior = .continuous
        case .text:
            itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(70))
            itemInset = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            orthogonalScrollingBehavior = .none
        }
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = itemInset ?? NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = orthogonalScrollingBehavior
        
        return section
    }
}
