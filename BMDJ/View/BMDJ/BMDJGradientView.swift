//
//  BMDJGradientView.swift
//  BMDJ
//
//  Created by 김진우 on 2022/01/09.
//

import UIKit

final class BMDJGradientView: UIView {
    
    // MARK: - UI Component
    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0, 0.2, 1]
        layer.addSublayer(gradientLayer)
        return gradientLayer
    }()
    
    // MARK: - Property
    var colors: [CGColor] = [] {
        didSet {
            gradientLayer.colors = colors
        }
    }
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
    
}
