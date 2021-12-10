//
//  EditPopupViewController.swift
//  BMDJ
//
//  Created by 김진우 on 2021/10/19.
//

import UIKit

import ReactorKit
import RxCocoa
import SnapKit

final class EditPopupViewController: UIViewController, View {
    
    // MARK: - UI Component
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 30
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var memoEditButton: UIButton = {
        let button = UIButton()
        contentView.addSubview(button)
        button.setTitle("메모 수정", for: .normal)
        button.setTitleColor(.font1, for: .normal)
        button.titleLabel?.font = .regularBody2
        button.contentHorizontalAlignment = .left
        self.contentView.addSubview(button)
        return button
    }()
    
    private lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = .line
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .regularBody2
        button.setTitle("메모 삭제", for: .normal)
        button.setTitleColor(.font1, for: .normal)
        button.contentHorizontalAlignment = .left
        self.contentView.addSubview(button)
        return button
    }()
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    var isDismiss = false {
        didSet {
            if isDismiss {
                DispatchQueue.main.async {
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
    
    // MARK: - LifeCycle
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        view.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isDismiss {
            self.dismiss(animated: false)
        }
    }
    
    func bind(reactor: EditPopupViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    @objc func tap() {
        dismissAnimation()
    }
    
    private func setLayout() {
        contentView.snp.makeConstraints {
            $0.height.equalTo(140 * AppService.shared.layoutScale)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(140 * AppService.shared.layoutScale)
        }
        
        memoEditButton.snp.makeConstraints {
            $0.height.equalTo(55 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(14 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(24 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-24 * AppService.shared.layoutScale)
        }
        
        line.snp.makeConstraints {
            $0.height.equalTo(1 * AppService.shared.layoutScale)
            $0.top.equalTo(memoEditButton.snp.bottom)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
            
        }
        
        deleteButton.snp.makeConstraints {
            $0.height.equalTo(55 * AppService.shared.layoutScale)
            $0.top.equalTo(line.snp.bottom)
            $0.left.equalToSuperview().offset(24 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-24 * AppService.shared.layoutScale)
        }
    }
    
    private func bindAction(_ reactor: EditPopupViewReactor) {
        deleteButton.rx.tap
            .map { _ in EditPopupViewReactor.Action.delete }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        memoEditButton.rx.tap
            .map { _ in reactor.reactorForeMemoEditView() }
            .bind { reactor in
                let editVC = MemoEditViewController(reactor: reactor)
                editVC.delegate = self
                editVC.modalPresentationStyle = .fullScreen
                DispatchQueue.main.async {
                    self.present(editVC, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: EditPopupViewReactor) {
        reactor.state.map { $0.dismiss }
            .bind { _ in
                let alertVC = AlertViewController(reactor: .init())
                alertVC.delegate = self
                alertVC.modalPresentationStyle = .overFullScreen
                DispatchQueue.main.async {
                    self.present(alertVC, animated: false)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func startAnimation() {
        contentView.snp.updateConstraints {
            $0.bottom.equalToSuperview()
        }
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func dismissAnimation() {
        contentView.snp.updateConstraints {
            $0.bottom.equalToSuperview()
        }
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)

        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: nil)
            }
        }

    }
}
