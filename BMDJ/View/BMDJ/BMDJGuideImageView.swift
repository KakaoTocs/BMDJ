//
//  BMDJGuideImageView.swift
//  BMDJ
//
//  Created by 김진우 on 2022/01/12.
//

import UIKit

final class BMDJGuideImageView: UIView {
    
    enum Guide {
        case first
        case second
        case third
        
        var image: UIImage? {
            switch self {
            case .first:
                return .init(named: "group1")
            case .second:
                return .init(named: "group2")
            case .third:
                return .init(named: "group3")
            }
        }
        
        var colors: [CGColor] {
            switch self {
            case .first:
                return [UIColor(hex: 0xE4E7FD).withAlphaComponent(0).cgColor, UIColor(hex: 0xE5E8FD).cgColor]
            case .second:
                return [UIColor(hex: 0x0B0B20).withAlphaComponent(0).cgColor, UIColor(hex: 0x0E0E21).cgColor]
            case .third:
                return [UIColor(hex: 0xFD956C).withAlphaComponent(0).cgColor, UIColor(hex: 0xFD966D).cgColor]
            }
        }
    }
    
    // MARK: - UI Component
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        addSubview(imageView)
        return imageView
    }()

    // MARK: - Init
    init(guide: Guide) {
        super.init(frame: .zero)
        
        setupUI()
        
        imageView.image = guide.image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    private func setupUI() {
        imageView.snp.makeConstraints {
            $0.height.equalTo(imageView.snp.width).multipliedBy(2.566866)
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(32 * AppService.shared.layoutScale)
            $0.trailing.equalToSuperview().offset(-32 * AppService.shared.layoutScale)
        }
    }
}
