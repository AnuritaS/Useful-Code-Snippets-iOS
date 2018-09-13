//
//  insertInTableCell.swift
//  WisOpt
//
//  Created by Anurita Srivastava on 08/12/17.
//  Copyright © 2017 MonkWish Production. All rights reserved.
//

import Foundation
//Insert at Bottom

self.yourArray.append(msg)

self.tblView.beginUpdates()
self.tblView.insertRows(at: [IndexPath.init(row: self.yourArray.count-1, section: 0)], with: .automatic)
self.tblView.endUpdates()
//Insert at Top of TableView

self.yourArray.insert(msg, at: 0)
self.tblView.beginUpdates()
self.tblView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
self.tblView.endUpdates()
