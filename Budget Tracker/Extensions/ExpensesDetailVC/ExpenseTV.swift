//
//  ExpenseTV.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-17.
//

import Foundation
import UIKit

extension ExpensesDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return self.expensesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "expense", for: indexPath) as! ExpenseTC
        
        cell.selectionStyle = .none
        cell.totalCategoryBudget = self.selectedCategory.budget!.decimalValue
        cell.setupCell(expense: self.expensesList[indexPath.row], colorIndex: Int(self.selectedCategory.colour))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedExpenseIndex = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteContextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            
            Alert.showDeleteConfirmationAlert(on: self, msg: "Are you sure you want to delete this Category?") { (actionResult) in
                
                if actionResult {
                    
                    let deleteExpense = self.expensesList[indexPath.row]
                    
                    if deleteExpense.eventId != nil && deleteExpense.eventId != "" {
                        Helper.deleteEvent(eventIdentifier: deleteExpense.eventId!)
                    }
                    
                    self.dataManager.deleteExpense(name: deleteExpense.note!) {
                        result in
                        
                        if result {
                            
                            self.updateTable()
                            
                        } else {
                            
                            Alert.showMessage(msg: "Unable to delete expense. Please try again later", on: self)
                        }
                    }
                   
                }
            }

        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteContextItem])

        return swipeActions
    }
}

