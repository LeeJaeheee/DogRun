//
//  SNSPostViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/23/24.
//

import UIKit
import SwiftUI
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher
import Alamofire

final class SNSPostViewController: BaseViewController<SNSPostView> {
    
    var postVC: UserFeedViewController!
    
    override func bind() {

    }
    
    override func configureView() {
        
        postVC = UserFeedViewController()
        addChild(postVC)
        mainView.containerView.addSubview(postVC.view)
        postVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        postVC.didMove(toParent: self)

    }
}


/*
 //extension UIColor {
 //    var color: Color {
 //        Color(self)
 //    }
 //}
 //
 //extension String: Identifiable {
 //    public var id: String {
 //        String(describing: self)
 //    }
 //}
 
 class SNSPostViewController: UIViewController {
 
 var posts: [PostResponse] = []
 
 let disposeBag = DisposeBag()
 
 let loginButton = UIButton()
 let loadPostButton = UIButton()
 
 override func viewDidLoad() {
 super.viewDidLoad()
 view.backgroundColor = .white
 
 view.addSubview(loginButton)
 loginButton.snp.makeConstraints { make in
 make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
 make.height.equalTo(40)
 }
 loginButton.setTitle("로그인", for: .normal)
 loginButton.backgroundColor = .blue
 
 view.addSubview(loadPostButton)
 loadPostButton.snp.makeConstraints { make in
 make.top.equalTo(loginButton.snp.bottom).offset(16)
 make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
 make.height.equalTo(40)
 }
 loadPostButton.setTitle("포스트", for: .normal)
 loadPostButton.backgroundColor = .blue
 
 loginButton.rx.tap
 .debounce(.seconds(1), scheduler: MainScheduler.instance)
 .flatMap { loginQuery in
 return NetworkManager.request(type: LoginResponse.self, router: UserRouter.login(model: .init(email: APIKey.testId.rawValue, password: APIKey.password.rawValue)))
 //return NetworkManager.createLogin(model: loginQuery)
 }
 .subscribe(with: self) { owner, loginModel in
 UserDefaults.standard.set(loginModel.accessToken, forKey: "accessToken")
 UserDefaults.standard.set(loginModel.refreshToken, forKey: "refreshToken")
 } onError: { owner, error in
 print("오류 발생")
 }
 .disposed(by: disposeBag)
 
 loadPostButton.rx.tap
 .debounce(.seconds(1), scheduler: MainScheduler.instance)
 .flatMap { loginQuery in
 return NetworkManager.request(type: PostsResponse.self, router: PostRouter.fetchPost(query: .init(next: nil, limit: nil, product_id: nil, hashTag: nil)))
 }
 .subscribe(with: self) { owner, response in
 owner.posts = response.data
 owner.configureImages()
 } onError: { owner, error in
 print("오류 발생")
 }
 .disposed(by: disposeBag)
 
 }
 
 func configureImages() {
 if let files = posts[4].files {
 let cardStack = CardStack(files) { imageURLString in
 RoundedRectangle(cornerRadius: 20, style: .continuous)
 .fill(Color.red)
 .overlay(
 Group {
 if let imageURL = URL(string: APIKey.baseURL.rawValue+"/"+imageURLString) {
 KFImage.init(imageURL)
 .resizable()
 .scaledToFill()
 .frame(width: 300, height: 400)
 } else {
 Rectangle()
 .fill(Color.gray)
 .frame(width: 300, height: 400)
 }
 }
 )
 .clipShape(RoundedRectangle(cornerRadius: 20))
 .frame(width: 300, height: 400)
 .onTapGesture {
 // Handle tap event if needed
 }
 .padding(50)
 }
 
 let hostingController = UIHostingController(rootView: cardStack)
 addChild(hostingController)
 view.addSubview(hostingController.view)
 
 hostingController.view.backgroundColor = .clear
 hostingController.view.snp.makeConstraints { make in
 make.center.equalToSuperview()
 make.width.equalTo(350)
 make.height.equalTo(500)
 }
 hostingController.didMove(toParent: self)
 }
 }
 
 }
 */
