//
//  ViewController.swift
//  DogRun
//
//  Created by 이재희 on 4/18/24.
//

import UIKit
import SwiftUI
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher
import Alamofire

class ViewController: UIViewController {
    
    var posts: [PostResponse] = []
    
    let disposeBag = DisposeBag()
    
    let loginButton = UIButton()
    let loadPostButton = UIButton()
    let myProfileButton = UIButton()
    
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
        
        view.addSubview(myProfileButton)
        myProfileButton.snp.makeConstraints { make in
            make.top.equalTo(loadPostButton.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        myProfileButton.setTitle("프로필", for: .normal)
        myProfileButton.backgroundColor = .blue
        
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
            } onError: { owner, error in
                print("오류 발생")
            }
            .disposed(by: disposeBag)
        
        /*
        myProfileButton.rx.tap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { loginQuery in
                return NetworkManager.request(type: ProfileResponse.self, router: UserRouter.getMyProfile)
            }
            .subscribe(with: self) { owner, response in
                dump(response)
                self.navigationController?.pushViewController(UserProfileViewController(), animated: true)
            } onError: { owner, error in
                print("오류 발생")
            }
            .disposed(by: disposeBag)
         */
    }
    
    
}

