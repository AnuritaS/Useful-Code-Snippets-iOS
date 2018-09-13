//
//  barTransparency.swift
//  WisOpt
//
//  Created by Anurita Srivastava on 07/12/17.
//  Copyright © 2017 MonkWish Production. All rights reserved.
//

import Foundation

func navigationBarTransparent(_ vc:UIViewController){
    vc.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    vc.navigationController?.navigationBar.barTintColor = .clear
}
func tabBarTransparent(_ vc:UIViewController){
    vc.tabBarController?.tabBar.backgroundImage = UIImage()
    vc.tabBarController?.tabBar.barTintColor = .clear
}
