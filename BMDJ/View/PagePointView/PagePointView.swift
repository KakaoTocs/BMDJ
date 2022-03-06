//
//  PagePointView.swift
//  BMDJ
//
//  Created by 김진우 on 2021/12/16.
//

import UIKit

final class PagePointView: UIView {
    
    var currentIndex: Int = 0 {
        didSet {
            if currentIndex >= 0,
               currentIndex < 3 {
                setIndex(currentIndex)
            }
        }
    }
    
    private lazy var pointStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 12 * AppService.shared.layoutScale
        addSubview(stackView)
        return stackView
    }()
    
    private lazy var pointViews: [UIView] = {
        return [pointView1, pointView2, pointView3]
    }()
    
    private lazy var pointView1: UIView = {
        let view = UIView()
        view.layer.cornerRadius = (8 * AppService.shared.layoutScale) / 2
        view.backgroundColor = .primary
        pointStackView.addArrangedSubview(view)
        return view
    }()
    
    private lazy var pointView2: UIView = {
        let view = UIView()
        view.layer.cornerRadius = (8 * AppService.shared.layoutScale) / 2
        view.backgroundColor = .init(hex: 0xb898ff)
        pointStackView.addArrangedSubview(view)
        return view
    }()
    
    private lazy var pointView3: UIView = {
        let view = UIView()
        view.layer.cornerRadius = (8 * AppService.shared.layoutScale) / 2
        view.backgroundColor = .init(hex: 0xb898ff)
        pointStackView.addArrangedSubview(view)
        return view
    }()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setLayout() {
        pointStackView.snp.makeConstraints {
            $0.width.equalTo(60 * AppService.shared.layoutScale)
            $0.height.equalTo(8 * AppService.shared.layoutScale)
            $0.center.equalToSuperview()
        }
        
        pointView1.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(20 * AppService.shared.layoutScale)
        }
        
        pointView2.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(8 * AppService.shared.layoutScale)
        }
        
        pointView3.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(8 * AppService.shared.layoutScale)
        }
    }
    
    private func setIndex(_ index: Int) {
        for view in pointViews {
            view.backgroundColor = .init(hex: 0xb898ff)
            view.snp.makeConstraints {
                $0.height.equalToSuperview()
                $0.width.equalTo(8 * AppService.shared.layoutScale)
            }
        }
        
        pointViews[index].backgroundColor = .primary
        pointViews[index].snp.remakeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalTo(20 * AppService.shared.layoutScale)
        }
    }
}
