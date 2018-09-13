//
//  tabBarShadow.swift
//  WisOpt
//
//  Created by Anurita Srivastava on 31/10/17.
//  Copyright © 2017 MonkWish Production. All rights reserved.
//

import Foundation

func tabBar(){
var tabbar = UITabBarController().tabBar
tabbar.barTintColor = UIColor.white
tabbar.isTranslucent = false
tabbar.layer.shadowColor = UIColor.black.cgColor
tabbar.layer.shadowOpacity = 0.2
tabbar.layer.shadowRadius = 10

tabbar.shadowImage = UIImage()
tabbar.backgroundImage = UIImage()

