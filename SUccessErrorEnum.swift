//
//  SUccessErrorEnum.swift
//  CoreDataTutorial
//
//  Created by Anurita Srivastava on 27/08/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation

enum Result <T>{
    case Success(T)
    case Error(String)
}
let service = APIService()
service.getDataWith { (result) in
    switch result {
    case .Success(let data):
        print(data)
    case .Error(let message):
        DispatchQueue.main.async {
            self.showAlertWith(title: "Error", message: message)
        }
    }
}

func showAlertWith(title: String, message: String, style: UIAlertControllerStyle = .alert) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
    let action = UIAlertAction(title: title, style: .default) { (action) in
        self.dismiss(animated: true, completion: nil)
    }
    alertController.addAction(action)
    self.present(alertController, animated: true, completion: nil)
}
