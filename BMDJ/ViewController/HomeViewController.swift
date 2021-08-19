//
//  HomeViewController.swift
//  BMDJ
//
//  Created by 김진우 on 2021/04/18.
//

import UIKit

import ReactorKit
import RxCocoa
import RxDataSources
import SnapKit

final class HomeViewController: UIViewController, View {
    
    private let STANDARD_WIDTH: CGFloat = 375
    private let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.width
    private let DANJI_CELL_RATIO: CGFloat = 1.493333
    private let MEMO_CELL_RATIO: CGFloat = 1.413461
    
    // MARK: - UI Componenet
    private lazy var backgroundView: UIView = {
        let view = UIView()
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var subView1: UIView = {
        let view = UIView()
        view.backgroundColor = .background3Gradarion1
        backgroundView.addSubview(view)
        return view
    }()
    
    private lazy var subView2: UIView = {
        let view = UIView()
        view.backgroundColor = .background3Gradarion2
        backgroundView.addSubview(view)
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        return scrollView
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.background3Gradarion1.cgColor, UIColor.background3Gradarion2.cgColor]
        return gradientLayer
    }()
    
    private lazy var contentsView: UIView = {
        let view = UIView()
        view.layer.addSublayer(gradientLayer)
        scrollView.addSubview(view)
        return view
    }()
    
    private lazy var topBar: UIView = {
        let view = UIView()
        contentsView.addSubview(view)
        return view
    }()
    
    private lazy var menuButton: UIButton = {
        let button = UIButton()
        button.setImage(.ic24BkHamburger, for: .normal)
        button.tintColor = .font1
        topBar.addSubview(button)
        return button
    }()
    
    private lazy var alarmButton: UIButton = {
        let button = UIButton()
        button.setImage(.ic24BkNotification, for: .normal)
        button.tintColor = .font1
        topBar.addSubview(button)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(.ic24BkShare, for: .normal)
        button.tintColor = .font1
        topBar.addSubview(button)
        return button
    }()
    
    // Danji
    private lazy var danjiCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = .init(width: SCREEN_WIDTH, height: UIScreen.main.bounds.width * DANJI_CELL_RATIO)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.register(DanjiCollectionCell.self, forCellWithReuseIdentifier: DanjiCollectionCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        contentsView.addSubview(collectionView)
        return collectionView
    }()
    
    private lazy var memoHeader: UIView = {
        let view = UIView()
        contentsView.addSubview(view)
        return view
    }()
    
    private lazy var memoTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .font1
        label.font = .BoldBody1
        label.text = "나의 메모"
        memoHeader.addSubview(label)
        return label
    }()
    
    private lazy var memoShowButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .regularBody3
        button.setTitleColor(.font1, for: .normal)
        button.setImage(.ic16BkDetailRight, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.setTitle("모든 메모 보기", for: .normal)
        button.tintColor = .font1
        memoHeader.addSubview(button)
        return button
    }()
    
    private lazy var memoCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .init(top: 12 * AppService.shared.layoutScale, left: 20 * AppService.shared.layoutScale, bottom: 50 * AppService.shared.layoutScale, right: 20 * AppService.shared.layoutScale)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 20 * AppService.shared.layoutScale
        flowLayout.scrollDirection = .horizontal
        let width = SCREEN_WIDTH - 63 * AppService.shared.layoutScale
        flowLayout.itemSize = .init(width: width , height: width * MEMO_CELL_RATIO)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(MemoCollectionCell.self, forCellWithReuseIdentifier: MemoCollectionCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        contentsView.addSubview(collectionView)
        return collectionView
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton()
        button.setImage(.ic40InactiveArrowLeft, for: .disabled)
        button.setImage(.ic40ActiveArrowLeft, for: .normal)
        danjiCollectionView.addSubview(button)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(.ic40InactiveArrowRight, for: .disabled)
        button.setImage(.ic40ActiveArrowRight, for: .normal)
        danjiCollectionView.addSubview(button)
        return button
    }()
    
    // MARK: - Property
    let activeMood: PublishRelay<Danji.Mood> = .init()
    var disposeBag = DisposeBag()
    
    lazy var danjiDataSource = RxCollectionViewSectionedReloadDataSource<DanjiSection>(
        configureCell: { _, collectionView, indexPath, reactor in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DanjiCollectionCell.identifier, for: indexPath) as! DanjiCollectionCell
            reactor.provider = self.reactor?.provider
            cell.reactor = reactor
            return cell
    })
    
    let memoDataSource = RxCollectionViewSectionedReloadDataSource<MemoSection>(
        configureCell: { _, collectionView, indexPath, reactor in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoCollectionCell.identifier, for: indexPath) as! MemoCollectionCell
            cell.reactor = reactor
            return cell
    })
    
    // MARK: - LifeCycle
    init(reactor: HomeViewReactor) {
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
        self.reactor = reactor
        DanjiClient.shared.all()
            .subscribe(onNext: { danjis in
                print(danjis.map { $0.id })
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradientLayer.frame = contentsView.bounds
    }
    
    func bind(reactor: HomeViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    // MARK: - Method
    private func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        subView1.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.5)
            $0.top.left.right.equalToSuperview()
        }
        
        subView2.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.5)
            $0.left.bottom.right.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.bottom.right.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        topBar.snp.makeConstraints {
            $0.height.equalTo(44 * AppService.shared.layoutScale)
            $0.top.left.right.equalToSuperview()
        }
        
        menuButton.snp.makeConstraints {
            $0.width.height.equalTo(40 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(2 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(12 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview().offset(-2 * AppService.shared.layoutScale)
        }
        
        shareButton.snp.makeConstraints {
            $0.width.height.equalTo(40 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(2 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-12 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview().offset(-2 * AppService.shared.layoutScale)
        }
        
        alarmButton.isHidden = true
        alarmButton.snp.makeConstraints {
            $0.width.height.equalTo(40 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(2 * AppService.shared.layoutScale)
            $0.right.equalTo(shareButton.snp.left).offset(-8 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview().offset(-2 * AppService.shared.layoutScale)
        }
        
        danjiCollectionView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.width * DANJI_CELL_RATIO)
            $0.top.equalTo(topBar.snp.bottom)
            $0.left.right.equalToSuperview()
        }

        memoHeader.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(72 * AppService.shared.layoutScale)
            $0.top.equalTo(danjiCollectionView.snp.bottom)
            $0.left.right.equalToSuperview()
        }
        
        memoTitleLabel.snp.makeConstraints {
            $0.height.equalTo(24 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(40 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
        }
        
        memoShowButton.snp.makeConstraints {
            $0.height.equalTo(24 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-16 * AppService.shared.layoutScale)
            $0.centerY.equalTo(memoTitleLabel)
        }

        memoCollectionView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.width * MEMO_CELL_RATIO)
            $0.top.equalTo(memoHeader.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        previousButton.snp.makeConstraints {
            $0.width.height.equalTo(40 * AppService.shared.layoutScale)
            $0.left.equalTo(view.snp.left).offset(20 * AppService.shared.layoutScale)
            $0.centerY.equalToSuperview()
        }
        
        nextButton.snp.remakeConstraints {
            $0.width.height.equalTo(40 * AppService.shared.layoutScale)
            $0.right.equalTo(view.snp.right).offset(-20 * AppService.shared.layoutScale)
            $0.centerY.equalToSuperview()
        }
        nextButton.layer.shadowOffset = .init(width: 2, height: 4)
        nextButton.layer.shadowOpacity = 0.2
        nextButton.layer.shadowRadius = 11 / 2
        let nextRect = nextButton.layer.bounds.insetBy(dx: -2, dy: -2)
        nextButton.layer.shadowPath = UIBezierPath(rect: nextRect).cgPath
    }
    
    private func bindAction(_ reactor: HomeViewReactor) {
        menuButton.rx.tap
            .map { reactor.reactorForMenu() }
            .subscribe(onNext: { [weak self] reactor in
                guard let `self` = self else { return }
                let viewController = MenuViewController()
                viewController.reactor = reactor
                viewController.modalPresentationStyle = .overFullScreen
                self.present(viewController, animated: false)
            })
            .disposed(by: disposeBag)
        
        shareButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                var image: URL?
                if let cell = self?.danjiCollectionView.visibleCells.first,
                   let danji = reactor.currentState.activeDanji {
                    let layer = self!.gradientLayer
                    image = cell.toImage(layerSize: layer.bounds.size, danji: danji)
                }
                if let url = image {
                    let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                    self?.present(activityVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        memoShowButton.rx.tap
            .map(reactor.reactorForMemoListView)
            .subscribe(onNext: { [weak self] memoListReactor in
                guard let `self` = self else { return }
                let memoListVC = MemoListViewController(reactor: memoListReactor)
                let naviVC = UINavigationController(rootViewController: memoListVC)
                naviVC.isNavigationBarHidden = true
                naviVC.modalPresentationStyle = .fullScreen
                self.present(naviVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        danjiCollectionView.rx.modelSelected(type(of: self.danjiDataSource).Section.Item.self)
            .subscribe(onNext: { [weak self] cellReactor in
                guard let `self` = self else { return }
                if cellReactor.currentState.color == .gray {
                    let viewController = DanjiPlantViewController()
                    viewController.reactor = .init(provider: reactor.provider)
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        memoCollectionView.rx.modelSelected(type(of: self.memoDataSource).Section.Item.self)
            .subscribe(onNext: { [weak self] cellReactor in
                guard let `self` = self else { return }
                if cellReactor.currentState.memoe.mood == .nomal,
                   let danji = reactor.currentState.activeDanji {
                    let addMemoVC = AddMemoViewController()
                    addMemoVC.modalPresentationStyle = .overFullScreen
                    addMemoVC.reactor = .init(provider: reactor.provider, activeDanji: danji)
                    self.present(addMemoVC, animated: true)
                } else {
                    let memoVC = MemoViewController(reactor: reactor.reactorForMemoView(cellReactor))
                    self.navigationController?.pushViewController(memoVC, animated: true)
                }
            })
//            .map(reactor.reactorForMemoView)
//            .subscribe(onNext: { [weak self] reactor in
//                guard let `self` = self else { return }
//                let memoVC = MemoViewController(reactor: reactor)
//                self.navigationController?.pushViewController(memoVC, animated: true)
//            })
            .disposed(by: disposeBag)
        
        previousButton.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .map { _ in reactor.currentState }
            .subscribe(onNext: { [weak self] state in
                if let index = state.activeIndex,
                   index - 1 > -1 {
                    self?.danjiCollectionView.scrollToItem(at: .init(item: index - 1, section: 0), at: .left, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .map { _ in reactor.currentState }
            .subscribe(onNext: { [weak self] state in
                if let maxCount = state.danjiSections.first?.items.count,
                   let index = state.activeIndex,
                   maxCount > index + 1 {
                    self?.danjiCollectionView.scrollToItem(at: .init(item: index + 1, section: 0), at: .right, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: HomeViewReactor) {
        reactor.state.asObservable().map { $0.danjiSections }
            .bind(to: danjiCollectionView.rx.items(dataSource: danjiDataSource))
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.memoSections }
            .bind(to: memoCollectionView.rx.items(dataSource: memoDataSource))
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.activeDanji }
            .filterNil()
            .map { $0.mood.gradient.map { $0.cgColor } }
            .bind(to: gradientLayer.rx.colors)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.activeDanji }
            .filterNil()
            .map { $0.mood.gradient.first }
            .bind(to: subView1.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.activeDanji }
            .filterNil()
            .map { $0.mood.gradient.last }
            .bind(to: subView2.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.activeDanji }
            .filterNil()
            .map { $0.mood == .happy ? .font1 : .white }
            .do(onNext: { v in
                self.memoShowButton.setTitleColor(v, for: .normal)
            })
            .bind(to: menuButton.rx.tintColor, alarmButton.rx.tintColor, shareButton.rx.tintColor, memoTitleLabel.rx.textColor, memoShowButton.rx.tintColor)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.isPreviousActive }
            .bind(to: previousButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.isNextActive }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        Observable.just(())
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable.just(())
            .map { Reactor.Action.refreshMemo }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func nextDanji() {
        let currentItem = (danjiCollectionView.indexPathsForVisibleItems.first ?? .init(item: 0, section: 0)).item
        let nextItem = min(currentItem + 1, danjiCollectionView.numberOfItems(inSection: 0) - 1)
        if currentItem == nextItem {
            return
        }
        DispatchQueue.main.async {
            self.danjiCollectionView.scrollToItem(at: .init(item: nextItem, section: 0), at: .top, animated: true)
        }
    }
    
    private func previousDanji() {
        let currentItem = (danjiCollectionView.indexPathsForVisibleItems.first ?? .init(item: 0, section: 0)).item
        let previousItem = max(currentItem - 1, 0)
        if currentItem == previousItem {
            return
        }
        DispatchQueue.main.async {
            self.danjiCollectionView.scrollToItem(at: .init(item: previousItem, section: 0), at: .top, animated: true)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: scrollView.frame.height / 2)
        if let index = danjiCollectionView.indexPathForItem(at: center),
           let reactor = reactor {
            Observable.just(index.item)
                .map { Reactor.Action.activeDanjiIndex($0) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item
        let layout = self.danjiCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인 // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
        let offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        // scrollView, targetContentOffset의 좌표 값으로 스크롤 방향을 알 수 있다.
        // index를 반올림하여 사용하면 item의 절반 사이즈만큼 스크롤을 해야 페이징이 된다.
        // 스크로로 방향을 체크하여 올림,내림을 사용하면 좀 더 자연스러운 페이징 효과를 낼 수 있다.
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else {
            roundedIndex = ceil(index)
        }
        if let reactor = reactor {
            Observable.just(Int(roundedIndex))
                .map { Reactor.Action.activeDanjiIndex($0) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
    }
}
