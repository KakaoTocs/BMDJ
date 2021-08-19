//
//  ImageImportButton.swift
//  BMDJ
//
//  Created by 김진우 on 2021/08/12.
//

import UIKit

protocol ImageImportButtonDelegate: AnyObject {
    func didSelected(image: UIImage?)
}

final class ImageImportButton: UIView {
    
    weak var delegate: ImageImportButtonDelegate?
    
    private lazy var buttonBorder: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: .zero, cornerRadius: 4).cgPath
        layer.strokeColor = UIColor.border.cgColor
        layer.lineDashPattern = [2, 2]
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.font1, for: .normal)
        button.layer.addSublayer(buttonBorder)
        button.setImage(.icBkImg, for: .normal)
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 2)
        button.titleEdgeInsets = .init(top: 0, left: 2, bottom: 0, right: 0)
        button.setTitle("사진 첨부", for: .normal)
        button.addTarget(self, action: #selector(importButtonAction), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.font5.cgColor
        imageView.layer.cornerRadius = 4 * AppService.shared.layoutScale
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeButtonAction))
        imageView.addGestureRecognizer(tapGesture)
        addSubview(imageView)
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "* 이미지를 변경하거나 삭제하려면\n  이미지를 누르세요"
        label.textColor = .font4
        label.numberOfLines = 0
        label.font = .regularCaption
        addSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        buttonBorder.path = UIBezierPath(roundedRect: button.bounds, cornerRadius: 4).cgPath
        buttonBorder.frame = button.bounds
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        setupUI()
        setLayout()
        setButtonEnable()
    }
    
    private func setLayout() {
        button.snp.makeConstraints {
            $0.height.equalTo(52 * AppService.shared.layoutScale)
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(80 * AppService.shared.layoutScale)
            $0.top.left.bottom.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.height.equalTo(30 * AppService.shared.layoutScale)
            $0.left.equalTo(imageView.snp.right).offset(16 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupUI() {
    }
    
    func setButtonEnable() {
        button.isHidden = false
        
        button.snp.remakeConstraints {
            $0.height.equalTo(52 * AppService.shared.layoutScale)
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        imageView.isHidden = true
        imageView.snp.removeConstraints()
        descriptionLabel.isHidden = true
        descriptionLabel.snp.removeConstraints()
    }
    
    func setImageEnable() {
        button.isHidden = true
        button.snp.removeConstraints()
        
        imageView.isHidden = false
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(80 * AppService.shared.layoutScale)
            $0.top.left.bottom.equalToSuperview()
        }
        
        descriptionLabel.isHidden = false
        descriptionLabel.snp.makeConstraints {
            $0.height.equalTo(30 * AppService.shared.layoutScale)
            $0.left.equalTo(imageView.snp.right).offset(16 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview()
        }
    }
    
    @objc func importButtonAction() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        DispatchQueue.main.async {
            if let vc = self.delegate as? UIViewController {
                vc.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    @objc func removeButtonAction() {
        print("Remove")
        imageView.image = nil
        setButtonEnable()
        delegate?.didSelected(image: nil)
    }
}

extension ImageImportButton: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image: UIImage? = nil
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = possibleImage
        }
        
//        addImageButton.snp.removeConstraints()
//        addImageButton.snp.remakeConstraints {
//            $0.width.height.equalTo(80 * AppService.shared.layoutScale)
//            $0.top.equalTo(titleLabel.snp.bottom).offset(16 * AppService.shared.layoutScale)
//            $0.left.equalToSuperview().offset(32 * AppService.shared.layoutScale)
//        }
//        addImageButton.setImage(image, for: .normal)
        if let image = image {
            delegate?.didSelected(image: image)
            imageView.image = image
        }
        setImageEnable()
        DispatchQueue.main.async {
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
