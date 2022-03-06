//
//  BMDJSearchBar.swift
//  BMDJ
//
//  Created by 김진우 on 2021/12/30.
//

import UIKit

import RxSwift

final class BMDJSearchBar: UIView {
    
    // MARK: - UI Component
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .search
        addSubview(imageView)
        return imageView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.font = .regularBody2
        textField.textColor = .font1
        textField.placeholder = "주식명, 종목(주식)코드 검색"
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        addSubview(textField)
        return  textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(.ic20Delete, for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(cancelButtonAction(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    // MARK: - Property
    let text = PublishSubject<String?>()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setLayout()
    }
    
    private func setLayout() {
        backgroundColor = .background2
        
        layer.cornerRadius = 4 * AppService.shared.layoutScale
        layer.borderColor = UIColor(hex: 0xE9E9E9).cgColor
        layer.borderWidth = 1 * AppService.shared.layoutScale
        
        iconImageView.snp.makeConstraints {
            $0.width.equalTo(iconImageView.snp.height)
            $0.top.equalToSuperview().offset(12 * AppService.shared.layoutScale)
            $0.leading.equalToSuperview().offset(12 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview().offset(-12 * AppService.shared.layoutScale)
        }
        
        textField.snp.makeConstraints {
            $0.height.equalTo(18 * AppService.shared.layoutScale)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12 * AppService.shared.layoutScale)
            $0.top.bottom.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.width.equalTo(cancelButton.snp.height)
            $0.top.equalToSuperview().offset(4 * AppService.shared.layoutScale)
            $0.leading.equalTo(textField.snp.trailing).offset(12 * AppService.shared.layoutScale)
            $0.trailing.equalToSuperview().offset(-6 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview().offset(-4 * AppService.shared.layoutScale)
        }
    }
    
    private func setHighilight(_ isHighlight: Bool) {
        if isHighlight {
            layer.borderColor = UIColor.primary.cgColor
            backgroundColor = .init(hex: 0xFCF9FF)
        } else {
            layer.borderColor = UIColor(hex: 0xE9E9E9).cgColor
            backgroundColor = .background2
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        cancelButton.isHidden = textField.text?.isEmpty ?? true
        text.onNext(textField.text)
    }
    
    @objc private func cancelButtonAction(_ button: UIButton) {
        cancelButton.isHidden = true
        textField.text = ""
        text.onNext("")
    }
}

extension BMDJSearchBar: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        setHighilight(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        setHighilight(false)
        return true
    }
}
