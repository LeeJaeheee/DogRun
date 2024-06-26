//
//  MainTabbarController.swift
//  DogRun
//
//  Created by 이재희 on 4/27/24.
//

import UIKit

class MainTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let feedNavigation = configureNavigationController(controller: FeedTabmanController(), title: "피드", imageName: "doc.text.image")
        let searchNavigation = configureNavigationController(controller: SearchViewController(), title: "검색", imageName: "number")
        let mapNavigation = configureNavigationController(controller: MapViewController(), title: "산책", imageName: "pawprint.circle.fill")
        let feedVC = UserFeedViewController()
        feedVC.viewModel.usertype = .like
        let likeNavigation = configureNavigationController(controller: feedVC, title: "좋아요", imageName: "bolt.heart.fill")
        let myPageNavigation = configureNavigationController(controller: UserViewController(), title: "마이페이지", imageName: "person")
        
        viewControllers = [feedNavigation, searchNavigation, mapNavigation, likeNavigation, myPageNavigation]
        
        selectedIndex = 2
    }

    private func configureNavigationController(controller: UIViewController, title: String, imageName: String) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: controller)
        //navigation.navigationBar.prefersLargeTitles = true
        //controller.navigationItem.title = title
        controller.view.backgroundColor = .white
        navigation.tabBarItem.title = title
        navigation.tabBarItem.image = UIImage(systemName: imageName)
        return navigation
    }
}
