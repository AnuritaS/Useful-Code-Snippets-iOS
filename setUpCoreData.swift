//
//  setUpCoreData.swift
//  JSONExport
//
//  Created by Anurita Srivastava on 26/08/18.
//  Copyright © 2018 Ahmed Ali. All rights reserved.
//

import Foundation

import Foundation
import CoreData
import UIKit

class ListDataSource<ObjectType: NSManagedObject, CellType: UITableViewCell>: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var fRC:NSFetchedResultsController<ObjectType>!
    
    var configureFunction: (CellType, ObjectType) -> Void
    
    var tableView:UITableView!
    var managedObjectContext: NSManagedObjectContext!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fRC != nil, let sections = fRC.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if fRC != nil, let sections = fRC.sections {
            return sections.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: delete(at: indexPath)
        default: () // Unsupported
        }
    }
    
    func delete(at indexPath: IndexPath){
        let objToDelete = fRC.object(at: indexPath)
        managedObjectContext.delete(objToDelete)
        try? managedObjectContext.save()
    }
    
    func addNotebook(name:String){
        let notebook = Notebook(context: managedObjectContext)
        notebook.name = name
        try? managedObjectContext.save()
    }
    
    func addNote(notebook:Notebook){
        let note = Note(context: managedObjectContext)
        note.attributedText = NSAttributedString(string: "New Note")
        note.notebook = notebook
        try? managedObjectContext.save()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = fRC.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(CellType.self)", for: indexPath) as! CellType
        
        configureFunction(cell, object)
        
        return cell
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: tableView.insertSections(indexSet, with: .fade)
        case .delete: tableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    init(tableView: UITableView, managedObjectContext: NSManagedObjectContext, fetchRequest: NSFetchRequest<ObjectType>, configure: @escaping (CellType, ObjectType) -> Void) {
        
        self.fRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        self.configureFunction = configure
        self.tableView = tableView
        self.managedObjectContext = managedObjectContext
        
        super.init()
        
        fRC.delegate = self
        
        do {
            try fRC.performFetch()
        } catch {
            fatalError("the shit just hitted the fan: \(error.localizedDescription)")
        }
        
    }
}

//
//  NotebooksListViewController.swift
//  Mooskine
//
//  Created by Josh Svatek on 2017-05-31.
//  Copyright © 2017 Udacity. All rights reserved.
//
import UIKit
import CoreData

class NotebooksListViewController: UIViewController {
    /// A table view that displays a list of notebooks
    @IBOutlet weak var tableView: UITableView!
    
    var dataController:DataController!
    
    var listDataSource:ListDataSource<Notebook, NotebookCell>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "toolbar-cow"))
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        listDataSource = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpFetchedResultsController()
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    fileprivate func setUpFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Notebook> = Notebook.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        listDataSource = ListDataSource(tableView: tableView, managedObjectContext: dataController.viewContext, fetchRequest: fetchRequest, configure: { (notebookCell, notebook) in
            notebookCell.nameLabel.text = notebook.name
            if let count = notebook.notes?.count {
                let pageString = count == 1 ? "page" : "pages"
                notebookCell.pageCountLabel.text = "\(count) \(pageString)"
            }
        })
        
        tableView.dataSource = listDataSource
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Actions
    @IBAction func addTapped(sender: Any) {
        presentNewNotebookAlert()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Editing
    /// Display an alert prompting the user to name a new notebook. Calls
    /// `addNotebook(name:)`.
    func presentNewNotebookAlert() {
        let alert = UIAlertController(title: "New Notebook", message: "Enter a name for this notebook", preferredStyle: .alert)
        
        // Create actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            if let name = alert.textFields?.first?.text {
                self?.listDataSource.addNotebook(name: name)
            }
        }
        saveAction.isEnabled = false
        
        // Add a text field
        alert.addTextField { textField in
            textField.placeholder = "Name"
            NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: textField, queue: .main) { notif in
                if let text = textField.text, !text.isEmpty {
                    saveAction.isEnabled = true
                } else {
                    saveAction.isEnabled = false
                }
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
    
    func updateEditButtonState() {
        
        if let sections = listDataSource.fRC.sections {
            navigationItem.rightBarButtonItem?.isEnabled = sections[0].numberOfObjects > 0
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Table view data source
    
    // -------------------------------------------------------------------------
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If this is a NotesListViewController, we'll configure its `Notebook`
        if let vc = segue.destination as? NotesListViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.notebook = listDataSource.fRC.object(at: indexPath)
                vc.dataController = dataController
            }
        }
    }
}
