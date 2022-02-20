//
//  StockSearchViewController.swift
//  BMDJ
//
//  Created by 김진우 on 2021/12/25.
//

import UIKit

import ReactorKit
import RxDataSources
import RxCocoa
import SnapKit

protocol StockSearchViewDelegate: AnyObject {
    func didSelected(stock: Stock)
}

final class StockSearchViewController: UIViewController, View {
    
    private let STOCK_CELL_RATIO: CGFloat = 0.144
    // MARK: - UI Component
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "보유 주식명 종목 검색"
        label.font = .semiBoldBody2
        label.textColor = .font1
        view.addSubview(label)
        return label
    }()
    
    private lazy var searchBar: BMDJSearchBar = {
        let searchBar = BMDJSearchBar()
        view.addSubview(searchBar)
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .init(top: 8 * AppService.shared.layoutScale, left: 0, bottom: 0, right: 8 * AppService.shared.layoutScale)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .vertical
        let width = UIScreen.main.bounds.width
        let height = width * STOCK_CELL_RATIO
        flowLayout.itemSize = .init(width: width, height: height)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(StockCell.self, forCellWithReuseIdentifier: StockCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        return collectionView
    }()
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    weak var delegate: StockSearchViewDelegate?
    
    lazy var stockDataSource = RxCollectionViewSectionedReloadDataSource<StockSection>(configureCell: { _, collectionView, indexPath, reactor in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StockCell.identifier, for: indexPath) as! StockCell
        cell.reactor = reactor
        return cell
    })
    
    // MARK: - Init
    init(reactor: StockSearchViewReactor) {
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    func bind(reactor: StockSearchViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        
        titleLabel.snp.makeConstraints {
            $0.width.equalTo(138 * AppService.shared.layoutScale)
            $0.height.equalTo(19 * AppService.shared.layoutScale)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30 * AppService.shared.layoutScale)
            $0.leading.equalToSuperview().offset(20 * AppService.shared.layoutScale)
        }
        
        searchBar.snp.makeConstraints {
            $0.height.equalTo(searchBar.snp.width).multipliedBy(0.143283)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8 * AppService.shared.layoutScale)
            $0.leading.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.trailing.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(16 * AppService.shared.layoutScale)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func bindAction(_ reactor: StockSearchViewReactor) {
        searchBar.text
            .map { Reactor.Action.search($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(type(of: self.stockDataSource).Section.Item.self)
            .bind { [weak self] stockReactor in
                self?.delegate?.didSelected(stock: stockReactor.initialState.stock)
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: StockSearchViewReactor) {
        reactor.state.map { $0.stockSections }
            .bind(to: collectionView.rx.items(dataSource: stockDataSource))
            .disposed(by: disposeBag)
    }
}

