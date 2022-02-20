//
//  MenuViewController.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/06.
//

import UIKit

import ReactorKit
import RxCocoa
import SnapKit

final class MenuViewController: UIViewController, View {
    
    var isDismiss = false
    // MARK: - UI Component
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 30
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .regularBody2
        button.setImage(UIImage(named: "ic24GrAdd"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle("장독대 추가", for: .normal)
        button.setTitleColor(.font1, for: .normal)
        button.contentHorizontalAlignment = .left
        contentView.addSubview(button)
        return button
    }()
    
    private lazy var line1: UIView = {
        let view = UIView()
        view.backgroundColor = .line
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .regularBody2
        button.setImage(UIImage(named: "ic24GrPot"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle("장독대 순서 편집", for: .normal)
        button.setTitleColor(.font1, for: .normal)
        button.contentHorizontalAlignment = .left
        contentView.addSubview(button)
        return button
    }()
    
    private lazy var line2: UIView = {
        let view = UIView()
        view.backgroundColor = .line
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var memoButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .regularBody2
        button.setImage(UIImage(named: "ic24GrMemo"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle("메모장", for: .normal)
        button.setTitleColor(.font1, for: .normal)
        button.contentHorizontalAlignment = .left
        contentView.addSubview(button)
        return button
    }()
    
    private lazy var line3: UIView = {
        let view = UIView()
        view.backgroundColor = .line
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var settingButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .regularBody2
        button.setImage(UIImage(named: "ic24GrSetting"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle("설정", for: .normal)
        button.setTitleColor(.font1, for: .normal)
        button.contentHorizontalAlignment = .left
        contentView.addSubview(button)
        return button
    }()
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
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
    
    func bind(reactor: MenuViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    @objc func tap() {
        dismissAnimation()
    }
    
    // MARK: - Method
    private func setLayout() {
        contentView.snp.makeConstraints {
            $0.height.equalTo(275 * AppService.shared.layoutScale)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(275 * AppService.shared.layoutScale)
        }
         
        addButton.snp.makeConstraints {
            $0.height.equalTo(40 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(32 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(24 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-24 * AppService.shared.layoutScale)
        }
        
        line1.snp.makeConstraints {
            $0.height.equalTo(1 * AppService.shared.layoutScale)
            $0.top.equalTo(addButton.snp.bottom).offset(8 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
        }
        
        editButton.snp.makeConstraints {
            $0.height.equalTo(40 * AppService.shared.layoutScale)
            $0.top.equalTo(line1.snp.bottom).offset(8 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(24 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-24 * AppService.shared.layoutScale)
        }
        
        line2.snp.makeConstraints {
            $0.height.equalTo(1 * AppService.shared.layoutScale)
            $0.top.equalTo(editButton.snp.bottom).offset(8 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
        }
        
        memoButton.snp.makeConstraints {
            $0.height.equalTo(40 * AppService.shared.layoutScale)
            $0.top.equalTo(line2.snp.bottom).offset(8 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(24 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-24 * AppService.shared.layoutScale)
        }
        
        line3.snp.makeConstraints {
            $0.height.equalTo(1 * AppService.shared.layoutScale)
            $0.top.equalTo(memoButton.snp.bottom).offset(8 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
        }
        
        settingButton.snp.makeConstraints {
            $0.height.equalTo(40 * AppService.shared.layoutScale)
            $0.top.equalTo(line3.snp.bottom).offset(8 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(24 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-24 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview().offset(-32 * AppService.shared.layoutScale)
        }
    }
    
    private func bindAction(_ reactor: MenuViewReactor) {
        addButton.rx.tap
            .map { reactor.reactorForPlantDanji() }
            .subscribe(onNext: { [weak self] reactor in
                guard let `self` = self else { return }
                let viewController = DanjiPlantViewController()
                viewController.reactor = reactor
                viewController.delegate = self
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        editButton.rx.tap
            .map { reactor.reactorForSortDanji() }
            .subscribe(onNext: { [weak self] reactor in
                guard let `self` = self else { return }
                let viewController = DanjiSortViewController()
                viewController.reactor = reactor
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        
        memoButton.rx.tap
            .map { reactor.reactorForAddMemo() }
            .subscribe(onNext: { [weak self]  reactor in
                if reactor?.currentState.memoCreate.danjiId == "empty" {
                    let sendErrorAlert = UIAlertView(title: "단지가 없습니다!", message: "단지를 먼저 심어주세요.", delegate: self, cancelButtonTitle: "확인")
                    sendErrorAlert.show()
                    return
                }
                guard let `self` = self else { return }
                let addMemoVC = AddMemoViewController()
                addMemoVC.modalPresentationStyle = .overFullScreen
                addMemoVC.delegate = self
                addMemoVC.reactor = reactor
                self.present(addMemoVC, animated: false)
            })
            .disposed(by: disposeBag)
        
        settingButton.rx.tap
            .map { reactor.reactorForSettingDanji() }
            .subscribe(onNext: { [weak self] reactor in
                guard let `self` = self else { return }
                let viewController = DanjiSettingViewController()
                viewController.reactor = reactor
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: MenuViewReactor) {
        reactor.state.asObservable().map { $0.isClose }
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.dismiss(animated: false)
            })
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
            $0.bottom.equalToSuperview().offset(275 * AppService.shared.layoutScale)
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
