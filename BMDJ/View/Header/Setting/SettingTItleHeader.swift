//
//  SettingTItleHeader.swift
//  BMDJ
//
//  Created by 김진우 on 2021/06/22.
//

import UIKit

import ReactorKit
import RxCocoa
import SnapKit

final class SettingTitleHeader: UITableViewHeaderFooterView, View {
    
    // MARK: - Static Property
    static let identifier = "SettingTitleHeader"
    
    // MARK: UI Component
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .semiBoldH3
        label.textColor = .font2
        contentView.addSubview(label)
        return label
    }()
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    // MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setLayout()
        contentView.backgroundColor = .background2
    }
//    init(reactor: SettingTitleHeaderReactor) {
//        super.init(reuseIdentifier: SettingTitleHeader.identifier)
//
//        self.reactor = reactor
//        setLayout()
//        backgroundColor = .background2
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: SettingTitleHeaderReactor) {
        bindState(reactor)
    }
    
    // MARK: - Private Method
    private func setLayout() {
        label.snp.makeConstraints {
            $0.height.equalTo(19 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(32 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
        }
    }
    
    private func bindState(_ reactor: SettingTitleHeaderReactor) {
        reactor.state.asObservable().map { $0 }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
}
