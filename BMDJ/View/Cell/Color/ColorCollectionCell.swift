//
//  ColorCollectionCell.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/22.
//

import UIKit

import ReactorKit

final class ColorCollectionCell: UICollectionViewCell, View {
    
    typealias Reactor = ColorCollectionCellReactor
    
    static let identifier = "ColorCollectionCell"
    
    
    override var isSelected: Bool {
        didSet {
            imageView.isHidden = !isSelected
            if isSelected {
                colorView.layer.borderWidth = 3
            } else {
                colorView.layer.borderWidth = 0
            }
        }
    }
    
    // MARK: - Component
    private lazy var colorView: UIView = {
        let view = UIView()
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.image = .icSelectCheck
        contentView.addSubview(imageView)
        return imageView
    }()
    
    var disposeBag: DisposeBag = .init()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    // MARK: - LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        colorView.layer.cornerRadius = bounds.height / 2
    }
    
    func bind(reactor: ColorCollectionCellReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    // MARK: - Private Method
    private func commonInit() {
        setLayout()
    }
    
    private func bindAction(reactor: Reactor) {
        
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state.asObservable().map { $0.color.color }
            .bind(to: colorView.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        colorView.layer.borderColor = UIColor(hex: 0x331574).cgColor
        
        colorView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(40 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(-14)
            $0.right.equalToSuperview().offset(14)
        }
    }
    
//    private func activeHighlight() {
//
//    }
//
//    private func inactiveHighlight() {
//        DispatchQueue.main.async {
//        }
//    }
}
