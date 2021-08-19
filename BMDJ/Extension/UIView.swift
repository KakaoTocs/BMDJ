//
//  UIView.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/23.
//

import UIKit

extension UIView {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        endEditing(true)
    }
    
    func toImage(layerSize: CGSize, danji: Danji) -> URL? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = .init(origin: .zero, size: layerSize)
        gradientLayer.colors = danji.mood.gradient.map { $0.cgColor }
        
        let parentView = DanjiCollectionCell(frame: .init(origin: .zero, size: bounds.size))
        parentView.reactor = .init(danji: danji)
//        parentView.layoutIfNeeded()
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        let currentView = UIView(frame: parentView.bounds)
        currentView.layer.addSublayer(gradientLayer)
        currentView.layer.addSublayer(parentView.layer)
        currentView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let referenceImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let newImage = referenceImage,
              let data = newImage.pngData() else {
            return nil
        }
        let url = FileUtility.cacheDirectoryURL.appendingPathComponent("Danji.png")
        FileUtility.shared.saveFile(at: url, data: data)
        return url
    }
}
