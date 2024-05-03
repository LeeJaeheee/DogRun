//
//  UserTabmanViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/25/24.
//

import UIKit
import SnapKit
import Tabman
import Pageboy

class UserTabmanViewController: TabmanViewController {
    
    private var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        configureTabBar(bar: bar)
        addBar(bar, dataSource: self, at: .top)
    }
    
    private func setupViewControllers() {
        let firstVC = UserGalleryViewController()
        let secondVC = UserFeedViewController()
        secondVC.viewModel.usertype = .specific
        let thirdVC = UserChallengeViewController()
        
        viewControllers = [firstVC, secondVC, thirdVC]
    }
    
    private func configureTabBar(bar: TMBar.ButtonBar) {
        bar.layout.transitionStyle = .snap
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        bar.layout.contentMode = .fit
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

extension UserTabmanViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "🐶 갤러리")
        case 1:
            return TMBarItem(title: "🎞️ 피드")
        case 2:
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
