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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expense", for: indexPath) as! ExpenseTC
        
        cell.setupCell(category: self.categoryList[indexPath.row])
        cell.delegate = self
        cell.index = indexPath.row

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedCategoryIndex = indexPath.row
        
        self.delegate?.ExpenseDetail(categoryData: categoryList[indexPath.row], categoryManageObject: categoryManageObjects[indexPath.row])
        
        self.updateCategoryTapCount(category: categoryList[indexPath.row], catObj: categoryManageObjects[indexPath.row])
        
        let cell = tableView.cellForRow(at: indexPath) as! ExpenseTC
        cell.isSelected = true

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
                            self.categoryManageObjects = self.dataManager.getCategoryList()
                            self.convertCategoryData()
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
