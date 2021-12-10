//
//  MemoCollectionCell.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/01.
//

import UIKit

import ReactorKit

final class MemoCollectionCell: UICollectionViewCell, View {
    
    typealias Reactor = MemoCollectionCellReactor
    
    static let identifier = "MemoCollectionCell"
    
    // MARK: - Component
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        contentView.layer.addSublayer(layer)
        return layer
    }()
    
    private lazy var moodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.shadowOffset = .init(width: 2, height: 2)
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowRadius = 2
        contentView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(hex: 0x575757)
        label.font = .regularBody2
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(.icEdit, for: .normal)
        contentView.addSubview(button)
        return button
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .regularBody2
        label.textColor = .font1
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xFFFFFF)
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        contentView.addSubview(imageView)
        return imageView
    }()
    
    // MARK: - Property
    var disposeBag: DisposeBag = DisposeBag()
    
    func bind(reactor: MemoCollectionCellReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = contentView.bounds
    }
    
    private func commonInit() {
        contentView.backgroundColor = .white
        
        layer.shadowOffset = .init(width: 2, height: 4)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 11 / 2
        let rect = layer.bounds.insetBy(dx: -2, dy: -2)
        layer.shadowPath = UIBezierPath(rect: rect).cgPath
    }
    
    private func setLayout() {
        gradientLayer.frame = contentView.bounds
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        moodImageView.snp.makeConstraints {
            $0.width.height.equalTo(48 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(24 * AppService.shared.layoutScale)
        }
        
        dateLabel.snp.makeConstraints {
            $0.width.equalTo(100 * AppService.shared.layoutScale)
            $0.height.equalTo(19 * AppService.shared.layoutScale)
            $0.leading.equalTo(moodImageView.snp.trailing).offset(16 * AppService.shared.layoutScale)
            $0.centerY.equalTo(moodImageView.snp.centerY)
        }
        
        editButton.snp.makeConstraints {
            $0.width.height.equalTo(40 * AppService.shared.layoutScale)
            $0.trailing.equalToSuperview().offset(-6 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(10 * AppService.shared.layoutScale)
        }
        
        textLabel.snp.makeConstraints {
            $0.height.equalTo(48 * AppService.shared.layoutScale)
            $0.top.equalTo(moodImageView.snp.bottom).offset(16 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(24 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-24 * AppService.shared.layoutScale)
        }
        
        line.snp.makeConstraints {
            $0.height.equalTo(1 * AppService.shared.layoutScale)
            $0.top.equalTo(textLabel.snp.bottom).offset(16 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(24 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-24 * AppService.shared.layoutScale)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(24 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(24 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-24 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview().offset(-32 * AppService.shared.layoutScale)
        }
    }
    
    private func bindAction(_ reactor: MemoCollectionCellReactor) {
        editButton.rx.tap
            .map { _ in MemoCollectionCellReactor.Action.edit }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: MemoCollectionCellReactor) {
        reactor.state.asObservable().map { $0.memoe.mood }
            .map { $0.image }
            .bind(to: moodImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.memoe.text }
            .bind(to: textLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.memoe.imageURL }
            .bind(to: imageView.kf.rx.image())
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.memoe.dateString }
            .do(onNext: { d in
                print(reactor.currentState.memoe.createDate)
            })
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0 }
            .filter { $0.isGradient }
            .map { $0.memoe.moodGradient }
            .bind(to: gradientLayer.rx.colors)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.isGradient }
            .map { $0 ? UIColor.white : .background2 }
            .bind(to: line.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.isGradient }
            .map { !$0 }
            .bind(to: editButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
