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
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var pagePointView: PagePointView = {
        let pagePointView = PagePointView()
        return pagePointView
    }()
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
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
        
    }
    
    private func bindAction(_ reactor: GuideViewReactor) {
        
    }
    
    private func bindState(_ reactor: GuideViewReactor) {
        
    }
}
