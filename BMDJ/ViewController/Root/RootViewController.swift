//
//  RootViewController.swift
//  BMDJ
//
//  Created by 김진우 on 2022/05/21.
//

import UIKit

import ReactorKit
import RxCocoa

final class RootViewController: UIViewController, View {
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    // MARK: - Init
    init(reactor: RootViewReactor) {
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    func bind(reactor: RootViewReactor) {
        bindState(reactor)
        bindAction(reactor)
    }
    
    private func setLayout() {
        
    }
    
    private func bindAction(_ reactor: RootViewReactor) {
        Observable.just(())
            .map { Reactor.Action.fetchToken }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: RootViewReactor) {
        reactor.state.compactMap { $0.token }
            .bind { [weak self] token in
                self?.presentHomeVC(reactor.dependency.homeViewReactor)
            }
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.presentLoginVC }
            .bind { [weak self] _ in
                self?.presentLoginVC(reactor.dependency.loginViewReactor)
            }
            .disposed(by: disposeBag)
    }
    
    private func presentHomeVC(_ reactor: HomeViewReactor) {
        DispatchQueue.main.async { [weak self] in
            let homeVC = HomeViewController(reactor: reactor)
            self?.navigationController?.pushViewController(homeVC, animated: false)
        }
    }
    
    private func presentLoginVC(_ reactor: LoginViewReactor) {
        DispatchQueue.main.async { [weak self] in
            let loginVC = LoginViewController(reactor: reactor)
            loginVC.modalPresentationStyle = .fullScreen
            self?.navigationController?.pushViewController(loginVC, animated: false)
        }
    }
}
