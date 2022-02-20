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
        let state = reactor.currentState
        dDayLabel.text = state.dDayString
//        reactor.state.asObservable().map { $0.danji.dDayString }
//            .bind(to: dDayLabel.rx.text)
//            .disposed(by: disposeBag)
        
        nickNameLabel.text = state.nickName
//        reactor.state.asObservable().map { $0.danji.name }
//            .bind(to: nickNameLabel.rx.text)
//            .disposed(by: disposeBag)
        
        weatherView.isHappy = state.mood
//        reactor.state.asObservable().map { $0.danji.mood }
//            .bind(to: weatherView.rx.isHappy)
//            .disposed(by: disposeBag)
        
        stockNameLabel.text = state.stockName
//        reactor.state.asObservable().map { $0.name }
//            .bind(to: stockNameLabel.rx.text)
//            .disposed(by: disposeBag)
        
        stockCountLabel.text = state.volume
//        reactor.state.asObservable().map { $0.danji.volume }
//            .bind(to: stockCountLabel.rx.text)
//            .disposed(by: disposeBag)
        
        danjiImageView.image = state.danjiImage
//        reactor.state.asObservable().map { $0.danji.color }
//            .map { $0.image }
//            .bind(to: danjiImageView.rx.image)
//            .disposed(by: disposeBag)
        
        landImageView.image = state.landImage
//        reactor.state.asObservable().map { $0.danji.landImage }
//            .bind(to: landImageView.rx.image)
//            .disposed(by: disposeBag)
        
        dDayLabel.textColor = state.moodColor
        nickNameLabel.textColor = state.moodColor
        stockNameLabel.textColor = state.moodColor
        stockCountLabel.textColor = state.moodColor
//        reactor.state.asObservable().map { $0.danji.mood }
//            .map { $0 == .happy ? .font1 : .white }
//            .bind(to: dDayLabel.rx.textColor, nickNameLabel.rx.textColor, stockNameLabel.rx.textColor, stockCountLabel.rx.textColor)
//            .disposed(by: disposeBag)
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
