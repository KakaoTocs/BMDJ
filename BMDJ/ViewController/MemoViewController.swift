//
//  MemoViewController.swift
//  BMDJ
//
//  Created by 김진우 on 2021/06/08.
//

import UIKit

import ReactorKit
import RxCocoa
import SnapKit
import RxKingfisher

final class MemoViewController: UIViewController, View {
    
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
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    override  func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let ratio = (imageView.image?.size.height ?? 1) / (imageView.image?.size.width ?? 1)
        imageView.snp.remakeConstraints {
            $0.height.equalTo(imageView.snp.width).multipliedBy(ratio)
            $0.top.equalTo(contentLabel.snp.bottom).offset(20 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview().offset(-24 * AppService.shared.layoutScale)
        }
    }
    
    init(reactor: MemoViewReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
        setLayout()
        self.view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: MemoViewReactor) {
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
            $0.bottom.equalToSuperview().offset(-24 * AppService.shared.layoutScale)
        }
    }
    
    private func bindAction(_ reactor: MemoViewReactor) {
        backButton.rx.tap
            .subscribe(onNext: { _ in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: MemoViewReactor) {
//        reactor.state.asObservable().map { $0.createDateString }
//            .bind(to: titleLabel.rx.text)
//            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.mood }
            .map { $0.image }
            .bind(to: moodImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.text }
            .bind(to: contentLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.imageURL }
            .bind(to: imageView.kf.rx.image())
            .disposed(by: disposeBag)
        
    }
}
