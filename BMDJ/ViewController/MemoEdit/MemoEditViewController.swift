//
//  MemoEditViewController.swift
//  BMDJ
//
//  Created by 김진우 on 2021/11/03.
//

import UIKit

import ReactorKit
import RxCocoa
import SnapKit
import RxKingfisher

final class MemoEditViewController: UIViewController, View {
    
    private let IMAGEVIEW_RATIO: CGFloat = 0.640718
    
    // MARK: - UI Component
    private lazy var topBar: UIView = {
        let view = UIView()
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(.ic24BkBack, for: .normal)
        topBar.addSubview(button)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regularBody2
        label.textColor = .font1
        topBar.addSubview(label)
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        scrollView.addSubview(view)
        return view
    }()
    
    private lazy var moodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.shadowOffset = .init(width: 2, height: 2)
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowRadius = 2
        
        contentView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var contentLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.isScrollEnabled = false
        label.font = .regularBody2
        label.textColor = .font1
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        contentView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4 * AppService.shared.layoutScale
        button.backgroundColor = .primary
        button.setTitle("수정 완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .BoldBody2
        self.view.addSubview(button)
        return button
    }()
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    weak var delegate: EditPopupViewController?
    
    // MARK: - LifeCycle
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let ratio = (imageView.image?.size.height ?? 1) / (imageView.image?.size.width ?? 1)
        imageView.snp.remakeConstraints {
            $0.height.equalTo(imageView.snp.width).multipliedBy(ratio)
            $0.top.equalTo(contentLabel.snp.bottom).offset(20 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview().offset(-108 * AppService.shared.layoutScale)
        }
    }
    
    init(reactor: MemoEditViewReactor) {
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
        self.reactor = reactor
        self.view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: MemoEditViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    // MARK: - Private Method
    private func setLayout() {
        topBar.snp.makeConstraints {
            $0.height.equalTo(44 * AppService.shared.layoutScale)
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints {
            $0.width.equalTo(100 * AppService.shared.layoutScale)
            $0.height.equalTo(19 * AppService.shared.layoutScale)
            $0.center.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(40 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(12 * AppService.shared.layoutScale)
            $0.centerY.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        moodImageView.snp.makeConstraints {
            $0.width.height.equalTo(47 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(32 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(moodImageView.snp.bottom).offset(16 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(20 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview().offset(-108 * AppService.shared.layoutScale)
        }
        
        saveButton.snp.makeConstraints {
            $0.height.equalTo(60 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview().offset(-24 * AppService.shared.layoutScale)
        }
    }
    
    private func bindAction(_ reactor: MemoEditViewReactor) {
        backButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismiss(animated: false)
            })
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .map { _ in self.contentLabel.text }
            .map(Reactor.Action.edit)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: MemoEditViewReactor) {
//        reactor.state.asObservable().map { $0.createDateString }
//            .bind(to: titleLabel.rx.text)
//            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.memo.mood }
            .map { $0.image }
            .bind(to: moodImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.memo.text }
            .bind(to: contentLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.memo.imageURL }
            .bind(to: imageView.kf.rx.image())
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isDismiss }
            .filter { $0 }
            .bind { _ in
                self.delegate?.isDismiss = true
                self.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
    }
}
