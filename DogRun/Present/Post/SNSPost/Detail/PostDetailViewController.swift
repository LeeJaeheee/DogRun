//
//  PostDetailViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/28/24.
//

import UIKit
import Kingfisher

// TODO: MVVM으로 리팩토링하기
final class PostDetailViewController: UIViewController {
    var scrollView = UIScrollView()
    var pageControl = UIPageControl()
    var imageView = UIImageView()
    
    var index: Int = 0
    
    // 이미지 URL 배열
    var imageUrls: [String] = ["https://picsum.photos/200", "https://picsum.photos/300"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupScrollView()
        setupPageControl()
        loadImages()
        
        // FIXME: sheet presentation 올라와있을때 뒤쪽 swipeDownGesture 막기
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissViewController))
        swipeDownGesture.direction = .down
        scrollView.addGestureRecognizer(swipeDownGesture)
        
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(presentNewViewController))
        swipeUpGesture.direction = .up
        scrollView.addGestureRecognizer(swipeUpGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollToInitialPage()
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func presentNewViewController() {
        let newViewController = UIViewController()
        newViewController.view.backgroundColor = .systemBackground
        if let sheet = newViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        newViewController.presentationController?.delegate = self

        UIView.animate(withDuration: 0.7, animations: {
            let halfOfSuperviewHeight = self.view.frame.size.height / 2
            self.scrollView.snp.remakeConstraints { make in
                make.top.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview().offset(-halfOfSuperviewHeight)
            }
            self.view.layoutIfNeeded()
        })
        
        present(newViewController, animated: true, completion: nil)
    }
    
    func setupScrollView() {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupPageControl() {
        pageControl.numberOfPages = imageUrls.count
        pageControl.currentPage = index
        view.addSubview(pageControl)
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func loadImages() {
//        for (index, imageUrl) in imageUrls.enumerated() {
//            let imageView = UIImageView()
//            imageView.kf.setImage(with: URL(string: imageUrl))
//            imageView.contentMode = .scaleAspectFill
//            imageView.clipsToBounds = true
//            let xPosition = self.view.frame.width * CGFloat(index)
//            imageView.frame = CGRect(x: xPosition, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//            
//            scrollView.contentSize.width = self.view.frame.width * CGFloat(index + 1)
//            scrollView.addSubview(imageView)
//        }
        var previousImageView: UIImageView? = nil
        for (index, imageUrl) in imageUrls.enumerated() {
            let imageView = UIImageView()
            imageView.kf.setImage(with: URL(string: imageUrl))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            scrollView.addSubview(imageView)

            imageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(scrollView.snp.width)
                make.height.equalTo(scrollView.snp.height)
                
                if let previousImageView = previousImageView {
                    make.leading.equalTo(previousImageView.snp.trailing)
                } else {
                    make.leading.equalToSuperview()
                }
            }
            previousImageView = imageView
        }

        previousImageView?.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }

        
    }
    
    func scrollToInitialPage() {
        let initialOffsetX = CGFloat(index) * view.frame.width
        scrollView.setContentOffset(CGPoint(x: initialOffsetX, y: 0), animated: false)
    }
}

extension PostDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

extension PostDetailViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        scrollView.snp.remakeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(presentationController.presentedView!.snp.top)
        }
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        })
    }
}

