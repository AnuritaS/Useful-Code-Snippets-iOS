//
//  stringToDate.swift
//  
//
//  Created by Anurita Srivastava on 11/07/17.
//
//

import Foundation

var string : String = "1408709486" // (Put your string here)

var timeinterval : NSTimeInterval = (string as NSString).doubleValue // convert it in to NSTimeInteral

var dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here

println(dateFromServer) // for My Example it will print : 2014-08-22 12:11:26 +0000


// Here i create a simple date formatter and print the string from DATE object. you can do it vise-versa.

var dateFormater : NSDateFormatter = NSDateFormatter()
dateFormater.dateFormat = "yyyy-MM-dd"
println(dateFormater.stringFromDate(dateFromServer)) // And then i can get the string like this : 2014-08-22
