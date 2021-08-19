//
//  LottieTestViewController.swift
//  BMDJ
//
//  Created by 김진우 on 2021/06/28.
//

import UIKit
import Lottie

final class LottieTestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAnimation()
    }
    
    func setAnimation() {
        let jsonName = "Rec"
        let animation = Animation.named(jsonName)

        // Load animation to AnimationView
        let animationView = AnimationView(animation: animation)
        animationView.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        animationView.loopMode = .loop
        // Add animationView as subview
        view.addSubview(animationView)

        // Play the animation
        animationView.play()
    }
}
