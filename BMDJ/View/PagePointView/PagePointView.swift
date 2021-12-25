//
//  PagePointView.swift
//  BMDJ
//
//  Created by 김진우 on 2021/12/16.
//

import UIKit

final class PagePointView: UIView {
    
    private lazy var pointStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
