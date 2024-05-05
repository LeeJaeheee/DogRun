//
//  FeedTabmanController.swift
//  DogRun
//
//  Created by 이재희 on 5/5/24.
//

import UIKit
import Tabman
import Pageboy

final class FeedTabmanController: TabmanViewController {
    private var viewControllers: [UIViewController] = []
    
    //var userId = UserDefaultsManager.all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        configureTabBar(bar: bar)
        addBar(bar, dataSource: self, at: .top)
        
    }
    
    private func setupViewControllers() {
        let firstVC = UserFeedViewController()
        firstVC.viewModel.usertype = .all
        //firstVC.viewModel.userId = userId
        let secondVC = UserFeedViewController()
        secondVC.viewModel.usertype = .all
        
        viewControllers = [firstVC, secondVC]
    }
    
    private func configureTabBar(bar: TMBar.ButtonBar) {
        bar.layout.transitionStyle = .snap
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        bar.layout.contentMode = .intrinsic
        bar.layout.interButtonSpacing = 20
        
        bar.backgroundView.style = .blur(style: .light)
        
        bar.buttons.customize { (button) in
            button.selectedTintColor = .black
            button.font = UIFont.systemFont(ofSize: 17)
            button.selectedFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        }
 
        bar.indicator.weight = .custom(value: 3)
    }
}

extension FeedTabmanController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "🎞️ 피드")
        case 1:
            return TMBarItem(title: "💸 챌린지")
        default:
            return TMBarItem(title: "Page \(index)")
        }
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        guard index < viewControllers.count else { return nil }
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: 0)
    }
}
