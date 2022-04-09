//
//  UIImage.swift
//  BMDJ
//
//  Created by 김진우 on 2022/04/07.
//

import UIKit

extension UIImageView {
    func startRotateAnimation() {
        let rotation: CABasicAnimation = .init(keyPath: "transform.rotation.z")
        rotation.fromValue = 360
        rotation.toValue = 0
        rotation.duration = 60
        rotation.isCumulative = true
        rotation.repeatCount = .greatestFiniteMagnitude
        DispatchQueue.main.async {
            self.layer.add(rotation, forKey: "rotationAnimation")
            self.layoutSubviews()
        }
    }
    
    func stopRotateAnimation() {
        DispatchQueue.main.async {
            self.layer.removeAnimation(forKey: "rotationAnimation")
            self.layoutSubviews()
        }
    }
}
