//
//  uiimage_alpha.swift
//  SignUp
//
//  Created by Anurita Srivastava on 06/05/18.
//  Copyright © 2018 Shreyash Sharma. All rights reserved.
//

import Foundation
extension UIImage {
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
