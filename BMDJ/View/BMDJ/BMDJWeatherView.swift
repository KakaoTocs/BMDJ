//
//  BMDJWeatherView.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/30.
//

import UIKit

import SnapKit

final class BMDJWeatherView: UIView {
    
    // MARK: - UI Component
    private lazy var sunImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .happySun
        addSubview(imageView)
        return imageView
    }()
    
    private lazy var cloudImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .happyCloud
        addSubview(imageView)
        return imageView
    }()
    
    private lazy var blackCloudImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .sadCloud
        addSubview(imageView)
        return imageView
    }()
    
    private lazy var rainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .sadRain
        addSubview(imageView)
        return imageView
    }()
    
    private lazy var blueTopCloudImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .emptyTopCloud
        addSubview(imageView)
        return imageView
    }()
    
    private lazy var blueBottomCloudImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .emptyBottomCloud
        addSubview(imageView)
        return imageView
    }()
    
    var isHappy: DanjiLite.Mood = .happy{
        didSet {
            switch isHappy {
            case .happy:
                onSun()
            case .sad:
                onSad()
            case .nomal, .empty:
                onEmpty()
            }
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commomInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commomInit() {
        setLayout()
    }
    
    private func setLayout() {
        sunImageView.snp.makeConstraints {
            $0.width.equalTo(229 * AppService.shared.layoutScale)
            $0.height.equalTo(317 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(17 * AppService.shared.layoutScale)
            $0.right.equalToSuperview()
        }
        
        cloudImageView.snp.makeConstraints {
            $0.width.equalTo(216 * AppService.shared.layoutScale)
            $0.height.equalTo(129 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(216 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-34 * AppService.shared.layoutScale)
        }
        
        blackCloudImageView.snp.makeConstraints {
            $0.width.equalTo(240 * AppService.shared.layoutScale)
            $0.height.equalTo(249 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(32 * AppService.shared.layoutScale)
            $0.right.equalToSuperview()
        }
        
        rainImageView.snp.makeConstraints {
            $0.width.equalTo(226 * AppService.shared.layoutScale)
            $0.height.equalTo(105 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(258 * AppService.shared.layoutScale)
            $0.right.equalToSuperview()
        }
        
        blueTopCloudImageView.snp.makeConstraints {
            $0.width.equalTo(253 * AppService.shared.layoutScale)
            $0.height.equalTo(249 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(44 * AppService.shared.layoutScale)
            $0.leading.equalToSuperview()
        }
        
        blueBottomCloudImageView.snp.makeConstraints {
            $0.width.equalTo(234 * AppService.shared.layoutScale)
            $0.height.equalTo(174 * AppService.shared.layoutScale)
            $0.top.equalTo(blueTopCloudImageView.snp.bottom).offset(-119 * AppService.shared.layoutScale)
            $0.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Method
    
    private func onSun() {
        sunImageView.isHidden = false
        cloudImageView.isHidden = false
        
        blackCloudImageView.isHidden = true
        rainImageView.isHidden = true
        
        blueTopCloudImageView.isHidden = true
        blueBottomCloudImageView.isHidden = true
    }
    
    private func onSad() {
        sunImageView.isHidden = true
        cloudImageView.isHidden = true
        
        blackCloudImageView.isHidden = false
        rainImageView.isHidden = false
        
        blueTopCloudImageView.isHidden = true
        blueBottomCloudImageView.isHidden = true
    }
    
    private func onEmpty() {
        sunImageView.isHidden = true
        cloudImageView.isHidden = true
        
        blackCloudImageView.isHidden = true
        rainImageView.isHidden = true
        
        blueTopCloudImageView.isHidden = false
        blueBottomCloudImageView.isHidden = false
    }
}
