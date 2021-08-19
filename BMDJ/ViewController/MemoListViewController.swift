//
//  MemoListViewController.swift
//  BMDJ
//
//  Created by 김진우 on 2021/06/20.
//

import UIKit

import RxDataSources
import ReactorKit
import RxCocoa
import SnapKit

final class MemoListViewController: UIViewController, View {

    private let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.width
    private let MEMO_CELL_RATIO: CGFloat = 1.413461
    
    // MARK: - UI Component
    private lazy var topBar: UIView = {
        let view = UIView()
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "모든 메모 보기"
        label.font = .regularBody2
        label.textColor = .font1
        topBar.addSubview(label)
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.ic24BkClose, for: .normal)
        topBar.addSubview(button)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .init(top: 32 * AppService.shared.layoutScale, left: 32 * AppService.shared.layoutScale, bottom: 32 * AppService.shared.layoutScale, right: 32 * AppService.shared.layoutScale)
        flowLayout.minimumLineSpacing = 24
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .vertical
        let width = SCREEN_WIDTH - 64 * AppService.shared.layoutScale
        let height = width * MEMO_CELL_RATIO
        flowLayout.itemSize = .init(width: width, height: height)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(MemoCollectionCell.self, forCellWithReuseIdentifier: MemoCollectionCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        return collectionView
    }()
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    lazy var memoDataSource = RxCollectionViewSectionedReloadDataSource<MemoSection>(configureCell: { _, collectionView, indexPath, reactor in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoCollectionCell.identifier, for: indexPath) as! MemoCollectionCell
        cell.reactor = reactor
        return cell
    })
    
    init(reactor: MemoListViewReactor) {
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
        view.backgroundColor = .white
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: MemoListViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func setLayout() {
        topBar.snp.makeConstraints {
            $0.height.equalTo(44 * AppService.shared.layoutScale)
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints {
            $0.width.equalTo(92 * AppService.shared.layoutScale)
            $0.height.equalTo(19 * AppService.shared.layoutScale)
            $0.center.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.width.height.equalTo(40 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-12 * AppService.shared.layoutScale)
            $0.centerY.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom)
            $0.left.bottom.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindAction(_ reactor: MemoListViewReactor) {
        closeButton.rx.tap
            .subscribe { _ in
                self.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(type(of: self.memoDataSource).Section.Item.self)
            .map(reactor.reactorForMemoView)
            .subscribe(onNext: { [weak self] reactor in
                guard let `self` = self else { return }
                let memoVC = MemoViewController(reactor: reactor)
                self.navigationController?.pushViewController(memoVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: MemoListViewReactor) {
        reactor.state.asObservable().map { $0.memoSections }
            .bind(to: collectionView.rx.items(dataSource: memoDataSource))
            .disposed(by: disposeBag)
    }
}
