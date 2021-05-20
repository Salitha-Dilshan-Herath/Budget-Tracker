//
//  ExpensesTV.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-14.
//

import Foundation
import UIKit

extension ExpensesCategoryTVC {
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        var sectionCount: Int = 0
        
        if categoryManageObjects.count > 0 {
            sectionCount = 1
            tableView.backgroundView = nil
            
        } else {
            
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width / 2, height: tableView.bounds.size.height))
            noDataLabel.text          = "              No Category is available \n \t       Please add your new \n \t         category by clicking the + icon."
            noDataLabel.textColor     = UIColor.black
            noDataLabel.numberOfLines = 3
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            sectionCount = 0
        }
        
        return sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryManageObjects.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cateogry", for: indexPath) as! CategoryTC
        
        let category = self.categoryManageObjects[indexPath.row] as! Category
        cell.setupCell(category: category)
        cell.delegate = self
        cell.index = indexPath.row
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedCategoryIndex = indexPath.row
        
        self.selectedCategory = self.categoryManageObjects[indexPath.row] as? Category
        
        if let updateCategory = dataManager.getCategory(name: self.selectedCategory.name!)?.first {
            self.selectedCategory     = updateCategory
            self.delegate?.ExpenseDetail(categoryData: selectedCategory)
        }
        
        self.updateCategoryTapCount()
        
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteContextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            
            Alert.showDeleteConfirmationAlert(on: self, msg: "Are you sure you want to delete this Category?") { (actionResult) in
                
                if actionResult {
                    
                    self.dataManager.deleteCategory(categoryObj: self.categoryManageObjects[indexPath.row]) {
                        result in
                        
                        if result {
                            self.categoryManageObjects = self.dataManager.getCategoryList(order: self.selectedOrderType)
                            
                            
                            self.tableView.reloadData()
                        } else {
                            print("Delete failed")
                        }
                    }
                }
            }
            
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteContextItem])
        
        return swipeActions
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }
    
}
