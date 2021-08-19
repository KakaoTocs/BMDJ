//
//  DanjiSortTableCell.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/23.
//

import UIKit

import ReactorKit

final class DanjiSortTableCell: UITableViewCell, View {
    
    typealias Reactor = DanjiSortTableCellReactor
    
    static let identifier = "DanjiSortTableCell"
    
    // MARK: - Component
    private lazy var danjiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.line.cgColor
        imageView.layer.cornerRadius = 4
        contentView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .mediumBody2
        label.textColor = .font1
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .mediumCaption
        label.textColor = .font3
        contentView.addSubview(label)
        return label
    }()
    
    var disposeBag: DisposeBag = .init()
    
    func bind(reactor: DanjiSortTableCellReactor) {
        reactor.state.asObservable().map { $0.color.thumbImage }
            .bind(to: danjiImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.stock.name }
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.name }
            .bind(to: nicknameLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        setLayout()
    }
    
    private func setLayout() {
        danjiImageView.snp.makeConstraints {
            $0.width.height.equalTo(42 * AppService.shared.layoutScale)
            $0.top.equalTo(12 * AppService.shared.layoutScale)
            
            $0.left.equalTo(20 * AppService.shared.layoutScale)
            $0.bottom.equalTo(-12 * AppService.shared.layoutScale)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.height.equalTo(19 * AppService.shared.layoutScale)
            $0.left.equalTo(danjiImageView.snp.right).offset(10 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(16 * AppService.shared.layoutScale)
        }
        
        nameLabel.snp.makeConstraints {
            $0.height.equalTo(15 * AppService.shared.layoutScale)
            $0.top.equalTo(nicknameLabel.snp.bottom)
            $0.left.equalTo(danjiImageView.snp.right).offset(10 * AppService.shared.layoutScale)
        }
    }
}
