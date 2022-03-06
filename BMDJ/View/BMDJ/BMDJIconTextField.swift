//
//  BMDJIconTextField.swift
//  BMDJ
//
//  Created by 김진우 on 2022/01/08.
//

import UIKit

protocol BMDJIconTextFieldDelegate: AnyObject {
    func didTap()
}

final class BMDJIconTextField: UIView {
    
    // MARK: - UI Component
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .search
        addSubview(imageView)
        return imageView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = .regularBody2
        textField.textColor = .font1
        textField.isUserInteractionEnabled = false
        addSubview(textField)
        return textField
    }()
    
    // MARK: - Property
    var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }
    var text: String? {
        didSet {
            textField.text = text
        }
    }
    weak var delegate: BMDJIconTextFieldDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    private func commonInit() {
        setLayout()
        setupUI()
    
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectAction(_:)))
        addGestureRecognizer(gesture)
        
    }
    
    private func setLayout() {
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(24 * AppService.shared.layoutScale)
            $0.leading.equalToSuperview().offset(12 * AppService.shared.layoutScale)
            $0.centerY.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(12 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(10 * AppService.shared.layoutScale)
            $0.trailing.equalToSuperview().offset(-12 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview().offset(-10 * AppService.shared.layoutScale)
        }
    }
    
    private func setupUI() {
        backgroundColor = .background2
        layer.borderWidth = 1
        layer.borderColor = UIColor.line.cgColor
        layer.cornerRadius = 4 * AppService.shared.layoutScale
        
    }
    
    @objc private func selectAction(_ sender: UITapGestureRecognizer) {
        delegate?.didTap()
    }
}
