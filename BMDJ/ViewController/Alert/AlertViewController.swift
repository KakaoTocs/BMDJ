//
//  AlertViewController.swift
//  BMDJ
//
//  Created by 김진우 on 2021/11/04.
//

import UIKit

import ReactorKit
import RxCocoa
import SnapKit

final class AlertViewController: UIViewController, View {
    
    // MARK: - UI Component
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 14 * AppService.shared.layoutScale
        view.clipsToBounds = true
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regularBody2
        label.textColor = .font1
        label.textAlignment = .center
        label.text = "메모가 삭제되었습니다."
        self.contentView.addSubview(label)
        return label
    }()
    
    private lazy var okButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldBody2
        button.backgroundColor = .primary
        self.contentView.addSubview(button)
        return button
    }()
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    weak var delegate: EditPopupViewController?
    
    // MARK: - Init
    init(reactor: AlertViewReactor) {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .black.withAlphaComponent(0.8)
        self.reactor = reactor
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: AlertViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    // MARK: - Private Method
    private func setLayout() {
        contentView.snp.makeConstraints {
            $0.width.equalTo(270 * AppService.shared.layoutScale)
            $0.height.equalTo(140 * AppService.shared.layoutScale)
            $0.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(24 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(36 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(16 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-16 * AppService.shared.layoutScale)
        }
        
        okButton.snp.makeConstraints {
            $0.height.equalTo(43 * AppService.shared.layoutScale)
            $0.left.bottom.right.equalToSuperview()
        }
    }
    
    private func bindAction(_ reactor: AlertViewReactor) {
        okButton.rx.tap
            .bind { _ in
                DispatchQueue.main.async {
                    self.delegate?.isDismiss = true
                    self.dismiss(animated: false)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: AlertViewReactor) {
    }
}
