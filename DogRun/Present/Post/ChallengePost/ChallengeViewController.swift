//
//  ChallengeViewController.swift
//  DogRun
//
//  Created by 이재희 on 5/6/24.
//

import UIKit
import RxSwift
import RxCocoa
import iamport_ios
import WebKit

final class ChallengeViewController: BaseViewController<ChallengeView> {
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    
    let viewModel = ChallengeViewModel()
    
    lazy var wkWebView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    override func configureView() {
        setDataSource()
        snapshot.appendSections([.init(id: SectionType.banner.rawValue), .init(id: SectionType.normalCarousel.rawValue), .init(id: SectionType.listCarousel.rawValue)])
    }
    
    override func bind() {
        let input = ChallengeViewModel.Input(loadBannerTrigger: BehaviorRelay<Void>(value: ()), loadChallengeTrigger: BehaviorRelay(value: ()))
        
        let output = viewModel.transform(input: input)
        
        output.bannerList
            .drive(with: self) { owner, banners in
                let items = banners.map { Item.banner($0) }
                owner.snapshot.appendItems(items, toSection: .init(id: SectionType.banner.rawValue))
                owner.dataSource?.apply(owner.snapshot)
            }
            .disposed(by: disposeBag)
        
        output.recommendList
            .drive(with: self) { owner, recommends in
                let items = recommends.map { Item.recommend($0) }
                owner.snapshot.appendItems(items, toSection: .init(id: SectionType.normalCarousel.rawValue))
                owner.dataSource?.apply(owner.snapshot)
            }
            .disposed(by: disposeBag)
        
        output.postList
            .drive(with: self) { owner, posts in
                let items = posts.map { Item.post($0) }
                owner.snapshot.appendItems(items, toSection: .init(id: SectionType.listCarousel.rawValue))
                owner.dataSource?.apply(owner.snapshot)
            }
            .disposed(by: disposeBag)
        
        output.requestFailure
            .bind(with: self) { owner, error in
                owner.errorHandler(error)
            }
            .disposed(by: disposeBag)
        
        output.paymentSuccess
            .bind(with: self) { owner, paymentResult in
                dump(paymentResult)
                owner.showToast("\(paymentResult.productName)\n\(paymentResult.price)원 결제가 완료되었습니다.🐶", position: .center)
            }
            .disposed(by: disposeBag)
        
        output.paymentFailure
            .bind(with: self) { owner, _ in
                print("결제 실패")
            }
            .disposed(by: disposeBag)
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item> (collectionView: mainView.collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self else { return UICollectionViewCell() }
            
            switch itemIdentifier {
            case .banner(let item):
                guard let cell = mainView.collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as? BannerCollectionViewCell else { return UICollectionViewCell() }
                cell.configureData(title: item.title)
                return cell
            case .recommend(let item):
                guard let cell = mainView.collectionView.dequeueReusableCell(withReuseIdentifier: NormalCarouselCollectionViewCell.identifier, for: indexPath) as? NormalCarouselCollectionViewCell else { return UICollectionViewCell() }
                cell.configureData(data: item)
                cell.registerButton.rx.tap
                    .debounce(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
                    .bind(with: self) { owner, _ in
                        owner.viewModel.registerIndex.accept(indexPath.item)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.registerButton.rx.tap
                    .debounce(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
                    .bind(with: self) { owner, index in
                        let challenge = item
                        let payment = IamportPayment(
                            pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
                            merchant_uid: "ios_\(APIKey.sesacKey.rawValue)_\(Int(Date().timeIntervalSince1970))",
                            amount: challenge.price).then {
                                $0.pay_method = PayMethod.card.rawValue
                                $0.name = challenge.title
                                $0.buyer_name = APIKey.buyerName.rawValue
                                $0.app_scheme = APIKey.appScheme.rawValue
                            }
                        
                        Iamport.shared.payment(viewController: self, userCode: APIKey.userCode.rawValue, payment: payment) { [weak self] iamportResponse in
                            guard let self, let response = iamportResponse, let uid = response.imp_uid else {
                                self?.showToast("결제 실패", position: .center)
                                return
                            }
                            let payments = PaymentsModel(
                                imp_uid: uid,
                                post_id: challenge.post_id,
                                productName: challenge.title,
                                price: Int(challenge.price)!
                            )
                            viewModel.paymentsRelay.accept(payments)
                        }
                        
                    }
                    .disposed(by: disposeBag)
                
                return cell
            case .post(let item):
                guard let cell = mainView.collectionView.dequeueReusableCell(withReuseIdentifier: ListCarouselCollectionViewCell.identifier, for: indexPath) as? ListCarouselCollectionViewCell else { return UICollectionViewCell() }
                cell.configureData(data: item)
                return cell
            }

        })
    }
    
}
