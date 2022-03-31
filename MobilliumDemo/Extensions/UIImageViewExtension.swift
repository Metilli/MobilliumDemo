//
//  UIImageViewExtension.swift
//  MobilliumDemo
//
//  Created by Metilli on 31.03.2022.
//

import Foundation
import UIKit
import Kingfisher

@IBDesignable
class GradientImageView: UIImageView{
    
    @IBInspectable var startColor: UIColor? = Constant.Color.gradientStart {
        didSet {updateGradient()}
    }
    
    @IBInspectable var endColor: UIColor? = Constant.Color.gradientEnd {
        didSet {updateGradient()}
    }
    
    @IBInspectable var gradientAlpha: CGFloat = 0.4{
        didSet {updateGradient()}
    }
    
    private var gradientView: GradientView?
    
    override func layoutSubviews() {
        installGradient()
        updateGradient()
    }
    
    func installGradient(){
        if gradientView == nil{
            gradientView = GradientView(frame: self.bounds)
            addSubview(gradientView!)
            bringSubviewToFront(gradientView!)
        }
    }
    
    func updateGradient() {
        gradientView?.startColor = startColor
        gradientView?.endColor = endColor
        gradientView?.alpha = gradientAlpha
    }
    
}
