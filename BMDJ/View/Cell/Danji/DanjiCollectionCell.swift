//
//  DanjiCollectionCell.swift
//  BMDJ
//
//  Created by 김진우 on 2021/04/27.
//

import UIKit

import RxCocoa
import RxRelay
import ReactorKit

//protocol DanjiCollectionCellDelegate: class {
////    var activeMood: PublishRelay<Danji.Mood> { get }
//    func changedMood(mood: Danji.Mood)
//}

final class DanjiCollectionCell: UICollectionViewCell, View {
    
    private let DANJI_WIDTH_SCALE: CGFloat = 0.672
    private let DANJI_HEIGHT_RATIO: CGFloat = 0.793650
    private let LAND_HEIGHT_RATIO: CGFloat = 0.133333
    
//    weak var delegate: DanjiCollectionCellDelegate?
    typealias Reactor = DanjiCollectionCellReactor
    
    static let identifier = "DanjiCollectionCell"
    
//    var provider: ServiceProviderType?
    private lazy var weatherView: BMDJWeatherView = {
        let view = BMDJWeatherView()
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var dDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .font1
        label.font = .boldH1
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .font1
        label.font = .boldH2
        contentView.addSubview(label)
        return label
    }()
    
    private(set) lazy var moodSwitch: BMDJMoodSwitch = {
        let `switch` = BMDJMoodSwitch()
        contentView.addSubview(`switch`)
        return `switch`
    }()
    
    private lazy var stockNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .font1
        label.font = .regularBody1
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var stockCountLabel: UILabel = {
        let label = UILabel()
        label.font = .regularBody1
        label.textColor = .font1
        label.alpha = 0.4
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var danjiImageView: UIImageView = {
        let imageView = UIImageView()
        contentView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var landImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(named: "happySoil")
        contentView.addSubview(imageView)
        return imageView
    }()
    
    
    var disposeBag: DisposeBag = .init()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        setLayout()
    }
    
    func bind(reactor: DanjiCollectionCellReactor) {
        moodSwitch.isOn = reactor.currentState.isHappy
        bindState(reactor)
        bindAction(reactor)
    }
    
    // MARK: - Private Method
    private func bindAction(_ reactor: DanjiCollectionCellReactor) {
        moodSwitch.rx.controlEvent(.valueChanged)
//            .subscribe(onNext: { value in
//                print(self.moodSwitch.isOn)
//            })
            .map { self.moodSwitch.isOn ? .happy : .sad }
            .map(Reactor.Action.setMood)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: DanjiCollectionCellReactor) {
        reactor.state.asObservable().map { $0.dDayString }
            .bind(to: dDayLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.name }
            .bind(to: nickNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.isHappy }
            .bind(to: weatherView.rx.isHappy)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.stock.name }
            .bind(to: stockNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.volume }
            .bind(to: stockCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.color }
            .map { $0.image }
            .bind(to: danjiImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.landImage }
            .bind(to: landImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.mood }
            .map { $0 == .happy ? .font1 : .white }
            .bind(to: dDayLabel.rx.textColor, nickNameLabel.rx.textColor, stockNameLabel.rx.textColor, stockCountLabel.rx.textColor)
            .disposed(by: disposeBag)
        
//        reactor.state.asObservable().map { $0.mood }
//            .map { $0 == .happy ? UIColor(hex: 0x412C0D) : UIColor(hex: 0x0B0031) }
//            .bind(to: landImageView.rx.tintColor)
//            .disposed(by: disposeBag)
        
//        reactor.state.asObservable().map { $0.mood }
//            .map { $0 == .happy ? }
    }
    
    private func setLayout() {
        weatherView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        dDayLabel.snp.makeConstraints {
            $0.height.equalTo(CGFloat(layoutValue: 60 * AppService.shared.layoutScale))
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(CGFloat(layoutValue: 50 * AppService.shared.layoutScale))
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.height.equalTo(CGFloat(layoutValue: 29 * AppService.shared.layoutScale))
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dDayLabel.snp.bottom).offset(CGFloat(layoutValue: 4 * AppService.shared.layoutScale))
        }
        
        moodSwitch.snp.makeConstraints {
            $0.width.equalTo(60 * AppService.shared.layoutScale)
            $0.height.equalTo(30 * AppService.shared.layoutScale)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(CGFloat(layoutValue: 16 * AppService.shared.layoutScale))
        }
        
        stockNameLabel.snp.makeConstraints {
            $0.height.equalTo(CGFloat(layoutValue: 24 * AppService.shared.layoutScale))
            $0.centerX.equalToSuperview()
            $0.top.equalTo(moodSwitch.snp.bottom).offset(CGFloat(layoutValue: 50 * AppService.shared.layoutScale))
        }
        
        stockCountLabel.snp.makeConstraints {
            $0.height.equalTo(CGFloat(layoutValue: 24 * AppService.shared.layoutScale))
            $0.centerX.equalToSuperview()
            $0.top.equalTo(stockNameLabel.snp.bottom).offset(CGFloat(layoutValue: 4 * AppService.shared.layoutScale))
        }
        
        danjiImageView.snp.makeConstraints {
            $0.width.equalTo(contentView.bounds.width * DANJI_WIDTH_SCALE)
            $0.height.equalTo(danjiImageView.snp.width).multipliedBy(DANJI_HEIGHT_RATIO)
//            $0.top.equalTo(stockCountLabel.snp.bottom).offset(CGFloat(layoutValue: 32 * AppService.shared.layoutScale))
            $0.centerX.equalToSuperview()
        }
        
        landImageView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(landImageView.snp.width).multipliedBy(LAND_HEIGHT_RATIO)
            $0.top.equalTo(danjiImageView.snp.bottom).offset(CGFloat(layoutValue: -13 * AppService.shared.layoutScale))
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
}
/*
 51.2+42.66666666
 +24.74666666+3.413333333
 +25.6+ 13.6533333333
 +20.48+42.666666666
 +20.48+ 3.41333333
 +145.63540992+27.30666666
 +42.66656-11.09333333
 */
// 452.8353032323

//extension Reactive where Base: DanjiCollectionCell {
//    var delegate: DelegateProxy<DanjiCollectionCell, DanjiCollectionCellDelegate> {
//        return RxDanjiCellDelegateProxy.proxy(for: self.base)
//    }
//}
