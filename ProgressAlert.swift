//
//  ProgressAlert.swift
//  
//
//  Created by Anurita Srivastava on 19/01/18.
//

import Foundation

let alertView = UIAlertController(title: "Please wait", message: "Upload progress!", preferredStyle: .alert)
alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

//  Show it to your users
self.present(alertView, animated: true, completion: {
    //  Add your progressbar after alert is shown (and measured)
    let margin:CGFloat = 8.0
    let rect = CGRect(x: margin,y: 72.0,width: alertView.view.frame.width - margin * 2.0 ,height: 2.0)
    let progressView = UIProgressView(frame: rect)
    progressView.progress = Float(progress.fractionCompleted)
    progressView.tintColor = UIColor.yellow
    alertView.view.addSubview(progressView)
})


