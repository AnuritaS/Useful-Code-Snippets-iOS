//
//  linkDetector.swift
//  
//
//  Created by Anurita Srivastava on 19/09/17.
//
//

import Foundation

var user_comment: UITextView = {
    let view = UITextView()
    view.backgroundColor = .clear;
    view.translatesAutoresizingMaskIntoConstraints = false;
    view.font = UIFont(name: "HelveticaNeue", size: UIDevice.current.userInterfaceIdiom == .pad ? 19 : 15)
    view.isEditable = false
    view.isSelectable = true
    view.dataDetectorTypes = UIDataDetectorTypes.all
    view.isScrollEnabled = false;
    return view;
    
}()
