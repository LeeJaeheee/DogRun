//
//  UploadPostView.swift
//  DogRun
//
//  Created by 이재희 on 5/1/24.
//

import UIKit

final class UploadPostView: ModeBaseView {
    
    let imageView = UIImageView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    override func configureHierarchy() {
        addSubview(imageView)
        addSubview(collectionView)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(300)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(-180)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        collectionView.backgroundColor = .clear
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.isScrollEnabled = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray4
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { section, environment in
            return UploadSectionType.allCases[section].createSection()
        }
        return layout
    }
    
}


