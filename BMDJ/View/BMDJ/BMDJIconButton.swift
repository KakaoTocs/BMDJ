//
//  BMDJIconButton.swift
//  BMDJ
//
//  Created by 김진우 on 2022/01/16.
//

import UIKit

final class BMDJIconButton: UIView {
    
    var text: String = "" {
        didSet {
            label.text = text
        }
    }
    
    var color: UIColor = .font1 {
        didSet {
            label.textColor = color
            imageView.tintColor = color
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .font1
        imageView.image = .ic16BkDetailRight
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .regularBody3
        label.textColor = .font1
        addSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setUI()
    }
    
    private func setUI() {
        imageView.snp.makeConstraints {
            $0.width.equalTo(imageView.snp.height)
            $0.top.trailing.bottom.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalTo(imageView.snp.leading)
        }
    }
}
