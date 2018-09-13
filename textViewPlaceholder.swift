//
//  textViewPlaceholder.swift
//  WisOpt
//
//  Created by Anurita Srivastava on 31/10/17.
//  Copyright © 2017 MonkWish Production. All rights reserved.
//

import UIKit

class textViewPlaceholder : UITextViewDelegate{

textView.text = "Placeholder"
textView.textColor = UIColor.lightGray

func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
        textView.text = nil
        textView.textColor = UIColor.black
    }
}

func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
        textView.text = "Placeholder"
        textView.textColor = UIColor.lightGray
    }
}
}
