//
//  GuideViewController.swift
//  BMDJ
//
//  Created by 김진우 on 2021/12/16.
//

import UIKit

import ReactorKit
import RxCocoa
import SnapKit

final class GuideViewController: UIViewController, View {
    
    typealias Reactor = GuideViewReactor
    
    // MARK: - UI Component
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.init(hex: 0xFFFBEF).cgColor, UIColor.init(hex: 0xE1E5FF).cgColor]
        view.layer.addSublayer(layer)
        return layer
    }()
    
    private lazy var nextButton: BMDJIconButton = {
        let button = BMDJIconButton()
        button.text = "다음"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nextButtonAction))
        button.addGestureRecognizer(tapGesture)
        
        view.addSubview(button)
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        scrollView.addSubview(contentView)
        return contentView
    }()
    
    private lazy var guideImageView1: BMDJGuideImageView = {
        let guideImageView = BMDJGuideImageView(guide: .first)
        contentView.addSubview(guideImageView)
        return guideImageView
    }()
    
    private lazy var guideImageView2: BMDJGuideImageView = {
        let guideImageView = BMDJGuideImageView(guide: .second)
        contentView.addSubview(guideImageView)
        return guideImageView
    }()
    
    private lazy var guideImageView3: BMDJGuideImageView = {
        let guideImageView = BMDJGuideImageView(guide: .third)
        contentView.addSubview(guideImageView)
        return guideImageView
    }()
    
    private lazy var gradientView: BMDJGradientView = {
        let gradientView = BMDJGradientView()
        view.addSubview(gradientView)
        return gradientView
    }()
    
    private lazy var pagePointView: PagePointView = {
        let pagePointView = PagePointView()
        view.addSubview(pagePointView)
        return pagePointView
    }()
    
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .boldBody2
        button.backgroundColor = .primary
        button.setTitle("시작하기", for: .normal)
        button.layer.cornerRadius = 4 * AppService.shared.layoutScale
        button.isHidden = true
        view.addSubview(button)
        return button
    }()
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    init(reactor: GuideViewReactor) {
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: GuideViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    // MARK: - Method
    private func setLayout() {
        gradientLayer.frame = view.bounds
        
        nextButton.snp.makeConstraints {
            $0.width.equalTo(50 * AppService.shared.layoutScale)
            $0.height.equalTo(24 * AppService.shared.layoutScale)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16 * AppService.shared.layoutScale)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16 * AppService.shared.layoutScale)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(nextButton.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide.snp.top)
            $0.leading.equalTo(scrollView.contentLayoutGuide.snp.leading)
            $0.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom)
            $0.trailing.equalTo(scrollView.contentLayoutGuide.snp.trailing)
            $0.width.equalTo(scrollView.snp.width).multipliedBy(3)
        }
        
        guideImageView1.snp.makeConstraints {
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(scrollView.snp.height)
            $0.leading.top.bottom.equalToSuperview()
        }
        
        guideImageView2.snp.makeConstraints {
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(scrollView.snp.height)
            $0.leading.equalTo(guideImageView1.snp.trailing)
            $0.top.bottom.equalToSuperview()
        }
        
        guideImageView3.snp.makeConstraints {
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(scrollView.snp.height)
            $0.leading.equalTo(guideImageView2.snp.trailing)
            $0.top.bottom.trailing.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints {
            $0.height.equalTo(100 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        pagePointView.snp.makeConstraints {
            $0.width.equalTo(60 * AppService.shared.layoutScale)
            $0.height.equalTo(6 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview().offset(-40)
            $0.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints {
            $0.height.equalTo(60 * AppService.shared.layoutScale)
            $0.leading.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview().offset(-24 * AppService.shared.layoutScale)
            $0.trailing.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
        }
    }
    
    private func bindAction(_ reactor: GuideViewReactor) {
        startButton.rx.tap
            .bind { _ in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: GuideViewReactor) {
        reactor.state.map { $0.currentIndex }
            .bind(to: pagePointView.rx.currentIndex)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.backgroundColor }
            .bind(to: gradientLayer.rx.colors)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.pointIndex }
            .filter { $0 == 0 }
            .map { _ in BMDJGuideImageView.Guide.first.colors }
            .bind(to: gradientView.gradientLayer.rx.colors)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.pointIndex }
            .filter { $0 == 1 }
            .map { _ in BMDJGuideImageView.Guide.second.colors }
            .bind(to: gradientView.gradientLayer.rx.colors)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.pointIndex }
            .filter { $0 == 2 }
            .map { _ in BMDJGuideImageView.Guide.third.colors }
            .bind(to: gradientView.gradientLayer.rx.colors)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.nextButtonColor }
            .bind(to: nextButton.rx.color)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.pointIndex }
            .map { !($0 == 2) }
            .bind(to: startButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentIndex }
            .map { !($0 == 2) }
            .bind(to: scrollView.rx.isScrollEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentIndex }
            .map { $0 == 2 }
            .bind(to: pagePointView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentIndex }
            .map { $0 == 2 }
            .bind(to: nextButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.pointIndex }
            .filter { $0 == 0 }
            .map { _ in BMDJGuideImageView.Guide.first.colors }
            .bind(to: gradientView.gradientLayer.rx.colors)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.pointIndex }
            .filter { $0 == 1 }
            .map { _ in BMDJGuideImageView.Guide.second.colors }
            .bind(to: gradientView.gradientLayer.rx.colors)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.pointIndex }
            .filter { $0 == 2 }
            .map { _ in BMDJGuideImageView.Guide.third.colors }
            .bind(to: gradientView.gradientLayer.rx.colors)
            .disposed(by: disposeBag)
    }
    
    @objc func nextButtonAction() {
        if let index = reactor?.currentState.currentIndex {
            let x = scrollView.bounds.width * CGFloat(index + 1)
            OperationQueue.main.addOperation {
                self.scrollView.setContentOffset(.init(x: x, y: 0), animated: true)
            }
        }
    }
}

extension GuideViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = (scrollView.contentOffset.x / scrollView.frame.size.width)
        let page = Int(point.rounded())
        if let reactor = reactor {
            Observable.just(Reactor.Action.scrollPoint(point))
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
            print(page)
        }
    }
}
