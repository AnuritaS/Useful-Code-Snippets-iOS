//
//  csvParser.swift
//  CoreDataPreloadDemo
//
//  Created by Anurita Srivastava on 25/08/18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation


extension AppDelegate{
    
    
    func parseCSV (contentsOfURL: URL, encoding: String.Encoding, error: NSErrorPointer) -> [(title:String, author:String)]? {
        // Load the CSV file and parse it
        let delimiter = ","
        var items:[(title:String, author:String)]?
        do{
            let content = try String(contentsOf: contentsOfURL)
            items = []
            let lines:[String] = content.components(separatedBy:(NSCharacterSet.newlines)) as [String]
            
            for line in lines {
                var values:[String] = []
                if line != "" {
                    // For a line with double quotes
                    // we use NSScanner to perform the parsing
                    if line.range(of: "\"") != nil {
                        var textToScan:String = line
                        var value:NSString?
                        var textScanner:Scanner = Scanner(string: textToScan)
                        while textScanner.string != "" {
                            
                            if (textScanner.string as NSString).substring(to: 1) == "\"" {
                                textScanner.scanLocation += 1
                                textScanner.scanUpTo("\"", into: &value)
                                textScanner.scanLocation += 1
                            } else {
                                textScanner.scanUpTo(delimiter, into: &value)
                            }
                            
                            // Store the value into the values array
                            values.append(value as! String)
                            
                            // Retrieve the unscanned remainder of the string
                            if textScanner.scanLocation < textScanner.string.count {
                                textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
                            } else {
                                textToScan = ""
                            }
                            textScanner = Scanner(string: textToScan)
                        }
                        
                        // For a line without double quotes, we can simply separate the string
                        // by using the delimiter (e.g. comma)
                    } else  {
                        values = line.components(separatedBy: delimiter)
                    }
                    
                    // Put the values into the tuple and add it to the items array
                    
                    let item = (title: values[0], author: values[1])
                    items?.append(item)
                }
            }
        }
        catch{
            print("error in content")
        }
        
        return items
    }
    
    
    func preloadData () {
        // Retrieve data from the source file
        if let contentsOfURL = Bundle.main.url(forResource: "books", withExtension: "csv") {
            
            // Remove all the menu items before preloading
            removeData()
            
            var error:NSError?
            if let items = parseCSV(contentsOfURL: contentsOfURL, encoding: String.Encoding.utf8, error: &error) {
                // Preload the menu items
                let managedObjectContext = dataControl.viewContext
                for item in items {
                    let book = NSEntityDescription.insertNewObject(forEntityName: "Books", into: managedObjectContext) as! Books
                    book.title = item.title
                    book.author = item.author
                    
                    try? managedObjectContext.save()
                }
            }
        }
    }
    
    func removeData () {
        // Remove the existing items
        let managedObjectContext = dataControl.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")
        var e: NSError?
        var books = [Books]()
        do{
            books = try managedObjectContext.fetch(fetchRequest) as! [Books]
        }catch{
            print("error in books")
        }
        
        if e != nil {
            print("Failed to retrieve record: \(e!.localizedDescription)")
            
        } else {
            
            for book in books {
                managedObjectContext.delete(book)
            }
        }
    }
    
}
