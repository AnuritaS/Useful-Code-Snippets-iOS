//
//  dismissKeyboard.swift
//  WisOpt
//
//  Created by Anurita Srivastava on 18/10/17.
//  Copyright © 2017 MonkWish Production. All rights reserved.
//

import Foundation

//self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector(“endEditing:”)))

func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return true;
}
NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
}

func keyboardWillHide(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += keyboardSize.height
        }
    }
}
