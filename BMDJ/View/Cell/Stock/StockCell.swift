//
//  StockCell.swift
//  BMDJ
//
//  Created by 김진우 on 2021/12/25.
//

import UIKit

import ReactorKit

final class StockCell: UICollectionViewCell, View {
    
    typealias Reactor = StockCellReactor
    
    static let identifier = "StockCell"
    
    // MARK: - Component
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldBody2
        label.textColor = .font1
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.font = .regularBody3
        label.textColor = .init(hex: 0x979797)
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.font = .regularBody3
        label.textColor = .init(hex: 0x979797)
        contentView.addSubview(label)
        return label
    }()
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    func bind(reactor: StockCellReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func setLayout() {
        nameLabel.snp.makeConstraints {
            $0.height.equalTo(19 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(8 * AppService.shared.layoutScale)
            $0.leading.equalToSuperview().offset(20 * AppService.shared.layoutScale)
        }
        
        indexLabel.snp.makeConstraints {
            $0.height.equalTo(17 * AppService.shared.layoutScale)
            $0.top.equalTo(nameLabel.snp.bottom).offset(2 * AppService.shared.layoutScale)
            $0.leading.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview().offset(-8 * AppService.shared.layoutScale)
        }
        
        codeLabel.snp.makeConstraints {
            $0.height.equalTo(17 * AppService.shared.layoutScale)
            $0.trailing.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview().offset(-8 * AppService.shared.layoutScale)
        }
    }
    
    private func bindAction(_ reactor: StockCellReactor) {
    }
    
    private func bindState(_ reactor: StockCellReactor) {
        let state = reactor.currentState
        let attributedString = NSMutableAttributedString(string: state.stock.name)
        attributedString.addAttribute(.foregroundColor, value: UIColor.primary, range: (state.stock.name as NSString).range(of: state.keyword))
        nameLabel.attributedText = attributedString
//        reactor.state
//            .map { state in
//
//                return attributedString
//            }
//            .bind(to: nameLabel.rx.attributedText)
//            .disposed(by: disposeBag)
        
        indexLabel.text = state.stock.index.rawValue
//        reactor.state.map { $0.stock.index.rawValue }
//            .bind(to: indexLabel.rx.text)
//            .disposed(by: disposeBag)
        
        codeLabel.text = state.stock.code
//        reactor.state.map { $0.stock.code }
//            .bind(to: codeLabel.rx.text)
//            .disposed(by: disposeBag)
    }
}
