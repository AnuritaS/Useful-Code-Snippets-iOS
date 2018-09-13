//
//  searchController.swift
//  Mooskine
//
//  Created by Anurita Srivastava on 27/08/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
//SETUP
let searchController = UISearchController(searchResultsController: nil)
// MARK: - View Setup
override func viewDidLoad() {
    super.viewDidLoad()
    // Setup the Scope Bar
    searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
    searchController.searchBar.delegate = self
    // Setup the search footer
    tableView.tableFooterView = searchFooter
    
    // Setup the Search Controllersr
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Candies"
    navigationItem.searchController = searchController
    definesPresentationContext = true
}
//USING Core Data
func setupFC(predicate: NSPredicate? = nil){
    let fetch:NSFetchRequest<Books> = Books.fetchRequest()
    let sort = NSSortDescriptor(key: "title", ascending: true)
    fetch.sortDescriptors = [sort]
    fetch.predicate = predicate
    fetchRC = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: dataControl.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    fetchRC.delegate = self
    do{
        try fetchRC.performFetch()
        
    } catch {
        print("Failed to retrieve record")
        print(error)
    }
}

}

 UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = fetchRC.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! bookCell
        cell.title.text = obj.title
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchRC.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchRC.sections?[0].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "assign", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AssignVC {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.book = fetchRC.object(at: indexPath)
                vc.dataControl = dataControl
                
            }
        }
    }
}
UISearchBarDelegate{
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return search.text?.isEmpty ?? true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBarIsEmpty(){
            setupFC()
        }else{
            let predicate1  = searchText.count > 0 ?
                NSPredicate(format:"title contains[cd] %@", searchText) : nil
            let predicate2  = searchText.count > 0 ?
                NSPredicate(format:"author contains[cd] %@", searchText) : nil
            let compound = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1!, predicate2!])
            setupFC(predicate: compound)
        }
        tableView.reloadData()
    }
    
}

//Using array
func searchBarIsEmpty() -> Bool {
    // Returns true if the text is empty or nil
    return searchController.searchBar.text?.isEmpty ?? true
}
//checking scope
func filterContentForSearchText(_ searchText: String, scope: String = "All") {
    filteredCandies = candies.filter({( candy : Candy) -> Bool in
        let doesCategoryMatch = (scope == "All") || (candy.category == scope)
        
        if searchBarIsEmpty() {
            return doesCategoryMatch
        } else {
            return doesCategoryMatch && candy.name.lowercased().contains(searchText.lowercased())
        }
    })
    tableView.reloadData()
}

extension MasterViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
}
extension MasterViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
//setting result count
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isFiltering() {
        searchFooter.setIsFilteringToShow(filteredItemCount: filteredCandies.count, of: candies.count)
        return filteredCandies.count
    }
    
    searchFooter.setNotFiltering()
    return candies.count
}

//USING API
