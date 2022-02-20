//
//  DanjiEmptyCell.swift
//  BMDJ
//
//  Created by 김진우 on 2021/12/25.
//

import UIKit

import ReactorKit

final class DanjiEmptyCell: UICollectionViewCell, View {
    
    typealias Reactor = DanjiEmptyCellReactor
    
    static let identifier = "DanjiEmptyCell"
    
    // MARK: - UI Component
    private lazy var weatherView: BMDJWeatherView = {
        let view = BMDJWeatherView()
        view.isUserInteractionEnabled = true
        addSubview(view)
        view.isHappy = .empty
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldH1
        label.textColor = .font1
        label.text = "D-day"
        addSubview(label)
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .boldBody1
        button.setTitle("단지 심으러 가기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .primary
        
        button.layer.cornerRadius = 24 * AppService.shared.layoutScale
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = .init(width: 0, height: 2)
        button.layer.shadowOpacity = 0.43
        button.layer.shadowRadius = 4
        button.isUserInteractionEnabled = false
        
        addSubview(button)
        return button
    }()
    
    private lazy var danjiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .potEmpty
        addSubview(imageView)
        return imageView
    }()
    
    private lazy var landImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .emptySoil
        imageView.isUserInteractionEnabled = true
        addSubview(imageView)
        return imageView
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
    func bind(reactor: DanjiEmptyCellReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func setLayout() {
        weatherView.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.width.equalTo(134 * AppService.shared.layoutScale)
            $0.height.equalTo(60 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(50 * AppService.shared.layoutScale)
            $0.centerX.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.width.equalTo(230 * AppService.shared.layoutScale)
            $0.height.equalTo(48 * AppService.shared.layoutScale)
            $0.top.equalTo(titleLabel.snp.bottom).offset(24 * AppService.shared.layoutScale)
            $0.centerX.equalToSuperview()
        }
        
        danjiImageView.snp.makeConstraints {
            $0.width.equalTo(247 * AppService.shared.layoutScale)
            $0.height.equalTo(196 * AppService.shared.layoutScale)
            $0.top.equalTo(button.snp.bottom).offset(143 * AppService.shared.layoutScale)
            $0.centerX.equalToSuperview()
        }
        
        landImageView.snp.makeConstraints {
            $0.height.equalTo(50 * AppService.shared.layoutScale)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bindAction(_ reactor: DanjiEmptyCellReactor) {
    }
    
    private func bindState(_ reactor: DanjiEmptyCellReactor) {
    }
}
