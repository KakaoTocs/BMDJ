//
//  SettingTableCell.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/23.
//

import UIKit

import ReactorKit

final class SettingTableCell: UITableViewCell, View {
    
    typealias Reactor = SettingTableCellReactor
    
    static let identifier = "SettingTableCell"
    
    // MARK: - Component
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regularBody3
        label.textColor = .font1
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .regularBody3
        label.textColor = .font2
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var `switch`: UISwitch = {
        let `switch` = UISwitch()
        `switch`.onTintColor = .primary
        contentView.addSubview(`switch`)
        return `switch`
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .detailRight
        contentView.addSubview(imageView)
        return imageView
    }()
    
    // MARK: - Property
    var disposeBag: DisposeBag = .init()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setLayout()
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(17 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.centerY.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints {
            $0.height.equalTo(17 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
            $0.centerY.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(40 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-8 * AppService.shared.layoutScale)
            $0.centerY.equalToSuperview()
        }
        
        `switch`.transform = .init(scaleX: AppService.shared.layoutScale, y: AppService.shared.layoutScale)
        `switch`.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
            $0.centerY.equalToSuperview()
        }
    }
    
    func bind(reactor: SettingTableCellReactor) {
        reactor.state.asObservable().map { $0.name }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.value == nil }
            .bind(to: valueLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.value != nil || $0.isSwitch }
            .bind(to: iconImageView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.value }
            .bind(to: valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { !$0.isSwitch }
            .bind(to: `switch`.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
