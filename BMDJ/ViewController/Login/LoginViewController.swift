//
//  LoginViewController.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/16.
//

import UIKit

import ReactorKit
import RxCocoa
import SnapKit

final class LoginViewController: UIViewController, View {
    
    // MARK: - UI Component
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .semiBoldH2
        label.textColor = .font1
        label.numberOfLines = 0
        label.text = "보물단지에 장독대를\n심어볼까요? ⚱️🍯"
        view.addSubview(label)
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .logo
        view.addSubview(imageView)
        return imageView
    }()
    
    private lazy var tourButton: UIButton = {
        let button = UIButton()
        button.setTitle("보물단지 둘러보기", for: .normal)
        button.titleLabel?.textColor = .font3
        button.titleLabel?.font = .regularBody3
        view.addSubview(button)
        return button
    }()
    
    private lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = .line
        self.view.addSubview(view)
        return view
    }()
    
//    private lazy var naverButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("네이버 아이디로 로그인", for: .normal)
//        button.setImage(.naverLogo, for: .normal)
//        button.semanticContentAttribute = .forceLeftToRight
//        button.titleLabel?.font = .regularBody3
//        button.backgroundColor = .naver
//        button.layer.cornerRadius = 4
//        view.addSubview(button)
//        return button
//    }()
//
//    private lazy var kakaoButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("카카오 계정으로 로그인", for: .normal)
//        button.setImage(.kakaotalkLogo, for: .normal)
//        button.semanticContentAttribute = .forceLeftToRight
//        button.titleLabel?.font = .regularBody3
//        button.backgroundColor = .kakao
//        button.setTitleColor(.font1, for: .normal)
//        button.layer.cornerRadius = 4
//        view.addSubview(button)
//        return button
//    }()
    
    private lazy var googleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Google로 로그인", for: .normal)
        button.setImage(.googleLogo, for: .normal)
        button.contentEdgeInsets = .init(top: 0, left: -12, bottom: 0, right: 0)
        button.semanticContentAttribute = .forceLeftToRight
        button.titleLabel?.font = .regularBody3
        button.backgroundColor = .google
        button.setTitleColor(.font1, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.line.cgColor
        button.layer.cornerRadius = 4
        view.addSubview(button)
        return button
    }()
    
    private lazy var appleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apple로 로그인", for: .normal)
        button.setImage(.appleLogo, for: .normal)
        button.contentEdgeInsets = .init(top: 0, left: -12, bottom: 0, right: 0)
        button.semanticContentAttribute = .forceLeftToRight
        button.titleLabel?.font = .regularBody3
        button.backgroundColor = .apple
        button.layer.cornerRadius = 4
        view.addSubview(button)
        return button
    }()
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    // MARK: - Init
    init(reactor: LoginViewReactor) {
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: LoginViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    // MARK: - Method
    private func setLayout() {
        view.backgroundColor = .white
        
        titleLabel.snp.makeConstraints {
            $0.width.equalTo(194 * AppService.shared.layoutScale)
            $0.height.equalTo(64 * AppService.shared.layoutScale)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50 * AppService.shared.layoutScale)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.width.equalTo(114 * AppService.shared.layoutScale)
            $0.height.equalTo(19 * AppService.shared.layoutScale)
            $0.top.equalTo(titleLabel.snp.bottom).offset(70 * AppService.shared.layoutScale)
            $0.centerX.equalToSuperview()
        }
        
        tourButton.snp.makeConstraints {
            $0.width.equalTo(101 * AppService.shared.layoutScale)
            $0.height.equalTo(17 * AppService.shared.layoutScale)
//            $0.top.equalTo(imageView.snp.bottom).offset(50 * AppService.shared.layoutScale)
            $0.centerX.equalToSuperview()
        }
        
        line.snp.makeConstraints {
            $0.height.equalTo(1 * AppService.shared.layoutScale)
            $0.top.equalTo(tourButton.snp.bottom).offset(16 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
        }
        
//        naverButton.snp.makeConstraints {
//            $0.height.equalTo(50 * AppService.shared.layoutScale)
//            $0.top.equalTo(line.snp.bottom).offset(40 * AppService.shared.layoutScale)
//            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
//            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
//        }
//
//        kakaoButton.snp.makeConstraints {
//            $0.height.equalTo(50 * AppService.shared.layoutScale)
//            $0.top.equalTo(naverButton.snp.bottom).offset(16 * AppService.shared.layoutScale)
//            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
//            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
//        }
        
        googleButton.snp.makeConstraints {
            $0.height.equalTo(50 * AppService.shared.layoutScale)
            $0.top.equalTo(line.snp.bottom).offset(40 * AppService.shared.layoutScale)
//            $0.top.equalTo(kakaoButton.snp.bottom).offset(16 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
        }
        
        appleButton.snp.makeConstraints {
            $0.height.equalTo(50 * AppService.shared.layoutScale)
            $0.top.equalTo(googleButton.snp.bottom).offset(16 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
        }
    }
    
    private func bindAction(_ reactor: LoginViewReactor) {
        appleButton.rx.tap
            .map { _ in Reactor.Action.appleLogin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        googleButton.rx.tap
            .map { _ in Reactor.Action.googleLogin(self) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: LoginViewReactor) {
        reactor.state.compactMap { $0.token }
            .bind { [weak self] token in
                guard let self = self else {
                    return
                }
                self.loginSuccess(token: token)
            }
            .disposed(by: disposeBag)
    }
    
    private func loginSuccess(token: String) {
        UserDefaultService.shared.write(token)
        
        let serviceProvider = ServiceProvider()
        serviceProvider.danjiDataBaseService.clear()
        serviceProvider.memoDataBaseService.clear()
        let reactor = reactor!.dependency.homeViewReactor
        
        DispatchQueue.main.async {
            let homeVC = HomeViewController(reactor: reactor)
            let naviVC = UINavigationController(rootViewController: homeVC)
            naviVC.isNavigationBarHidden = true
            UIApplication.shared.windows.first?.rootViewController = naviVC
        }
    }
}
