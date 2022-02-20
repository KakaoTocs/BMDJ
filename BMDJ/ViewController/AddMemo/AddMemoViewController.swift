//
//  AddMemoViewController.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/10.
//

import UIKit

import ReactorKit
import RxCocoa
import SnapKit

final class AddMemoViewController: UIViewController, View {
    
    private let CONTENTVIEW_HEIGHT_RATIO: CGFloat = 1.68
    
    weak var delegate: MenuViewController?
    
    // MARK: - UI Component
    private lazy var backgroundView: UIView = {
        let view = UIView()
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldBody1
        label.textColor = .font1
        label.text = "나의 메모"
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.ic24BkClose, for: .normal)
        button.setTitleColor(.font1, for: .normal)
        contentView.addSubview(button)
        return button
    }()
    
    private lazy var importButton: ImageImportButton = {
        let button = ImageImportButton()
        button.delegate = self
        contentView.addSubview(button)
        return button
    }()
    
    private lazy var moodTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .semiBoldBody2
        label.textColor = .font1
        label.text = "기분 설정"
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var moodSwitch: BMDJMoodSwitch = {
        let `switch` = BMDJMoodSwitch()
        `switch`.isOn = true
        contentView.addSubview(`switch`)
        return `switch`
    }()
    
    private lazy var moodLabel: UILabel = {
        let label = UILabel()
        label.font = .boldH2
        label.textColor = .font1
        label.text = "맑음"
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xEFEFEF)
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.text = "오늘 나의 보물단지에 대한 내용을 기록해 보세요."
        textView.textColor = .font3
        textView.font = .regularBody2
        contentView.addSubview(textView)
        return textView
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.backgroundColor = .primary
        button.setTitle("저장하기", for: .normal)
        button.titleLabel?.font = .bold16
        button.setTitleColor(.white, for: .normal)
        contentView.addSubview(button)
        return button
    }()
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    var isPresentOnly: Bool = false {
        didSet {
            if isPresentOnly {
                backgroundView.backgroundColor = .init(hex: 0x111111).withAlphaComponent(0.8)
            }
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setLayout()
    }
    
    func bind(reactor: AddMemoViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: AddMemoViewReactor) {
        closeButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        moodSwitch.rx.controlEvent(.valueChanged)
            .map { self.moodSwitch.isOn ? .happy : .sad }
            .map(Reactor.Action.updateMood)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        textView.rx.text
            .map { Reactor.Action.updateText($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .do(onNext: { _ in
                let vc = IndicatorViewController()
                self.view.addSubview(vc.view)
            })
            .map { Reactor.Action.save }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: AddMemoViewReactor) {
        reactor.state.asObservable().map { $0.dismiss }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: false, completion: {
                    self?.delegate?.dismiss(animated: false)
                })
            })
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.memoCreate.mood }
            .distinctUntilChanged()
            .map { $0 == .sad ? "슬픔" : "맑음"}
            .bind(to: moodLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    @objc func tap() {
        dismissAnimation()
    }
    
    private func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.height.equalTo(600 * AppService.shared.layoutScale)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(600 * AppService.shared.layoutScale)
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(24 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(40 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(32 * AppService.shared.layoutScale)
        }
        
        closeButton.snp.makeConstraints {
            $0.width.height.equalTo(40 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(32 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-12 * AppService.shared.layoutScale)
        }
        
        importButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(32 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-32 * AppService.shared.layoutScale)
        }
        
        moodTitleLabel.snp.makeConstraints {
            $0.top.equalTo(importButton.snp.bottom).offset(32 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(32 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-32 * AppService.shared.layoutScale)
        }
        
        moodSwitch.snp.makeConstraints {
            $0.width.equalTo(60 * AppService.shared.layoutScale)
            $0.height.equalTo(30 * AppService.shared.layoutScale)
            $0.top.equalTo(moodTitleLabel.snp.bottom).offset(16 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(32 * AppService.shared.layoutScale)
        }
        
        moodLabel.snp.makeConstraints {
            $0.width.equalTo(42 * AppService.shared.layoutScale)
            $0.height.equalTo(29 * AppService.shared.layoutScale)
            $0.left.equalTo(moodSwitch.snp.right).offset(20 * AppService.shared.layoutScale)
            $0.centerY.equalTo(moodSwitch)
        }
        
        line.snp.makeConstraints {
            $0.height.equalTo(1 * AppService.shared.layoutScale)
            $0.top.equalTo(moodSwitch.snp.bottom).offset(40 * AppService.shared.layoutScale)
            $0.left.equalTo(32 * AppService.shared.layoutScale)
            $0.right.equalTo(-32 * AppService.shared.layoutScale)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(24 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(32 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-32 * AppService.shared.layoutScale)
        }
            
        saveButton.snp.makeConstraints {
            $0.height.equalTo(60 * AppService.shared.layoutScale)
            $0.top.equalTo(textView.snp.bottom).offset(40 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview().offset(-24 * AppService.shared.layoutScale)
        }
    }
    
    func startAnimation() {
        contentView.snp.updateConstraints {
            $0.bottom.equalToSuperview()
        }
        view.backgroundColor = UIColor(red: 17 / 255, green: 17 / 255, blue: 17 / 255, alpha: 0.8)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func dismissAnimation() {
        contentView.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(600 * AppService.shared.layoutScale)
        }
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: nil)
            }
        }

    }
}

extension AddMemoViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .font3 {
            textView.text = nil
            textView.textColor = .font1
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "오늘 나의 보물단지에 대한 내용을 기록해 보세요."
            textView.textColor = .font3
        }
    }
}

extension AddMemoViewController: ImageImportButtonDelegate {
    func didSelected(image: UIImage?) {
        if let reactor = reactor {
            Observable.just(())
                .map { Reactor.Action.selectImage(image) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
    }
}
