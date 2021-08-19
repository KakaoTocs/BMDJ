//
//  BMDJTextField.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/19.
//

import UIKit

final class BMDJTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 16 * AppService.shared.layoutScale, y: bounds.origin.y, width: bounds.width - 32 * AppService.shared.layoutScale, height: bounds.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 16 * AppService.shared.layoutScale, y: bounds.origin.y, width: bounds.width - 32 * AppService.shared.layoutScale, height: bounds.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        comomInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        comomInit()
    }
    
    private func comomInit() {
        setLayout()
        setupUI()
        
        addTarget(self, action: #selector(handleEditing), for: .allEditingEvents)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setLayout()
    }
    
    private func setLayout() {
        clearButtonMode = .whileEditing
        
        if let clearButton = value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.frame = .init(x: bounds.width - 40 * AppService.shared.layoutScale, y: 14 * AppService.shared.layoutScale, width: 20 * AppService.shared.layoutScale, height: 20 * AppService.shared.layoutScale)
            clearButton.setImage(.ic20Delete, for: .normal)
        }
        borderStyle = .line
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }
    
    private func setupUI() {
        backgroundColor = .background2
        layer.borderWidth = 1
        layer.borderColor = UIColor.line.cgColor
        font = .regularBody2
    }
    
    @objc private func handleEditing() {
        updateBorder()
    }
    
    private func updateBorder() {
        let borderColor: UIColor = isFirstResponder ? .primary : .init(hex: 0xE9E9E9)
        let backgroundColor: UIColor = isFirstResponder ? .init(hex: 0xFCF9FF) : .background2
        
        UIView.animate(withDuration: 0.3) {
            self.layer.borderColor = borderColor.cgColor
            self.backgroundColor = backgroundColor
        }
    }
}
