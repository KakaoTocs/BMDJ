//
//  IndicatorViewController.swift
//  BMDJ
//
//  Created by 김진우 on 2021/08/18.
//

import UIKit

final class IndicatorViewController: UIViewController {
    
    static let notiDismissKey = Notification.Name("IndicatorViewController_dismiss")
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.backgroundColor = .white
        indicator.tintColor = .font1
        indicator.layer.cornerRadius = 10 * AppService.shared.layoutScale
        view.addSubview(indicator)
        return indicator
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissNoti(_:)), name: IndicatorViewController.notiDismissKey, object: nil)
        setLayout()
        
        indicator.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        indicator.stopAnimating()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        indicator.snp.makeConstraints {
            $0.width.height.equalTo(60 * AppService.shared.layoutScale)
            $0.center.equalToSuperview()
        }
    }
    @objc func dismissNoti(_ notification: Notification) {
        DispatchQueue.main.async {
            self.dismiss(animated: false)
        }
    }
}
