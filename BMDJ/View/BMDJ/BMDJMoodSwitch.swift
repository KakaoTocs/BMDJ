//
//  BMDJMoodSwitch.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/22.
//

import UIKit

import SnapKit

final class BMDJMoodSwitch: UIControl {
    
    // MARK: - Component
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .sad
        addSubview(imageView)
        return imageView
    }()
    
    // MARK: - Property
    var isOn: Bool = false {
        didSet {
            updateUI()
            sendActions(for: .valueChanged)
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupLayout()
        updateUI()
        
        backgroundColor = UIColor(hex: 0x323232)
        
        layer.borderWidth = 2
        layer.borderColor = UIColor(hex: 0x1E1E1E).cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        addGestureRecognizer(tapGesture)
    }
     
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
        
    }
    
    private func updateUI() {
        imageView.snp.remakeConstraints {
            $0.width.equalTo(imageView.snp.height)
            $0.height.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        layoutIfNeeded()
        if isOn {
            imageView.image = .happy
            imageView.snp.makeConstraints {
                $0.right.equalToSuperview()
            }
        } else {
            imageView.image = .sad
            imageView.snp.makeConstraints {
                $0.left.equalToSuperview()
            }
        }
        UIView.animate(withDuration: 0.2, delay: 0, options:.curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func setupLayout() {
        imageView.snp.makeConstraints {
            $0.width.equalTo(imageView.snp.height)
            $0.height.equalToSuperview()
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    @objc func tap() {
        isOn.toggle()
    }
}
