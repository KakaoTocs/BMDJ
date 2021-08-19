//
//  DayCollectionCell.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/22.
//

import UIKit

import ReactorKit

final class DayCollectionCell: UICollectionViewCell, View {
    
    typealias Reactor = DayCollectionCellReactor
    
    static let identifier = "DayCollectionCell"
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .semiBoldBody2
        contentView.addSubview(label)
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                label.textColor = .white
                contentView.backgroundColor = .primary
            } else {
                label.textColor = .font1
                contentView.backgroundColor = .white
            }
        }
    }
    
    var disposeBag: DisposeBag = .init()
    
    func bind(reactor: DayCollectionCellReactor) {
        reactor.state.asObservable().map { $0.day }
            .map { "\($0)일" }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = bounds.height / 2
        let rect = layer.bounds.insetBy(dx: -1, dy: -1)
        contentView.layer.shadowPath = UIBezierPath(rect: rect).cgPath
        
    }
    
    private func commonInit() {
        setLayout()
        setUI()
    }
    
    private func setUI() {
        contentView.backgroundColor = .white
        
        layer.shadowOffset = .init(width: 0, height: 2)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 7 / 2
    }
    
    private func setLayout() {
        label.snp.makeConstraints {
            $0.height.equalTo(20 * AppService.shared.layoutScale)
            $0.center.equalToSuperview()
        }
    }
}
