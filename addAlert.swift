//
//  addAlert.swift
//  LibraryManagementSystem
//
//  Created by Anurita Srivastava on 11/09/18.
//  Copyright © 2018 Anurita Srivastava. All rights reserved.
//

import Foundation
func presentNewbookAlert() {
    let alert = UIAlertController(title: "New book", message: "Enter book's details", preferredStyle: .alert)
    
    // Create actions
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
        guard let title = alert.textFields![0].text else {
            return
        }
        guard let author = alert.textFields?[1].text else {
            return
        }
        
        self?.dataSource.addBook(title: title, author: author)
    }
    saveAction.isEnabled = false
    
    // Add a text field
    alert.addTextField(configurationHandler: {textField in
        textField.placeholder = "Title"
        if let text = textField.text, text.isEmpty {
            saveAction.isEnabled = false
        }
    })
    alert.addTextField(configurationHandler:{textField in
        textField.placeholder = "Author"
        if let text = textField.text, text.isEmpty {
            saveAction.isEnabled = false
        }
    })
    
    
    saveAction.isEnabled = true
    
    alert.addAction(cancelAction)
    alert.addAction(saveAction)
    present(alert, animated: true, completion: nil)
}
