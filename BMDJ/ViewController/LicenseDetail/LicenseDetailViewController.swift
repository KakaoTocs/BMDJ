//
//  LicenseDetailViewController.swift
//  BMDJ
//
//  Created by 김진우 on 2021/09/05.
//

import UIKit

import ReactorKit
import SnapKit

final class LicenseDetailViewController: UIViewController, View {
    
    typealias Reactor = LicenseDetailViewReactor
    
    // MARK: - UI Component
    private lazy var topBar: UIView = {
        let view = UIView()
        view.backgroundColor = .background2
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .regularBody2
        topBar.addSubview(label)
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.ic24BkClose, for: .normal)
        topBar.addSubview(button)
        return button
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .regularBody3
        textView.backgroundColor = .background2
        textView.isEditable = false
        view.addSubview(textView)
        return textView
    }()
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    init(reactor: LicenseDetailViewReactor) {
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: LicenseDetailViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func setLayout() {
        view.backgroundColor = .background2
        
        topBar.snp.makeConstraints {
            $0.height.equalTo(44 * AppService.shared.layoutScale)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.width.height.equalTo(40 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-12 * AppService.shared.layoutScale)
            $0.centerY.equalToSuperview()
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom).offset(20 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.bottom.right.equalTo(view.safeAreaLayoutGuide).offset(-20 * AppService.shared.layoutScale)
        }
    }
    
    private func bindAction(_ reactor: LicenseDetailViewReactor) {
        closeButton.rx.tap
            .subscribe(onNext: { _ in
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: LicenseDetailViewReactor) {
        reactor.state.asObservable().map { $0.text }
            .bind(to: textView.rx.text)
            .disposed(by: disposeBag)
    }
}
