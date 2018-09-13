//
//  preloadDB.swift
//  CoreDataPreloadDemo
//
//  Created by Anurita Srivastava on 25/08/18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation
import CoreData
//find location of database

class DataController{
    
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    init(modelName: String){
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (()-> Void)? = nil){
        persistentContainer.loadPersistentStores(completionHandler: {storeDesc, error in
            guard error == nil else{
                fatalError(error!.localizedDescription)
            }
            self.autoSave(interval: 3)
            completion?()
        })
        
    }
    
}

extension DataController{
    func autoSave(interval:TimeInterval = 30){
        guard interval > 0 else{
            print("cannot set negative autosave interval")
            return
        }
        if viewContext.hasChanges{
            try? viewContext.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+interval, execute: {
            self.autoSave(interval: interval)
        })
    }
}


//in AppDelegate
let dataControl = DataController(modelName: "LibraryMS")
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    dataControl.load()
    let navControl = window?.rootViewController as! UINavigationController
    let booksVC = navControl.topViewController as! ViewController
    booksVC.dataControl = dataControl
    preloadData()
    
    return true
}
lazy var applicationDocumentsDirectory: URL = {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.appcoda.CoreDataDemo" in the application's documents Application Support directory.
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[urls.count-1] as URL
}()


// MARK: - Core Data Saving support

func saveContext(){
    try? dataControl.viewContext.save()
}
