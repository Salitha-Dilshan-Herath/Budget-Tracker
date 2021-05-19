//
//  CoreDataManager.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-12.
//

import Foundation
import UIKit
import CoreData

struct CoreDataManager {
    
    private var appDelegate: AppDelegate?
    private var manageContent: NSManagedObjectContext?
    
    init() {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.appDelegate = appDelegate
            self.manageContent     = self.appDelegate!.persistentContainer.viewContext
        }
        
    }
    
    //MARK: - Category Functions
    func saveCategory(categoryDetail: CategoryData, completion: @escaping (Bool) -> Void) {
        
        let categoryEntity    = NSEntityDescription.entity(forEntityName: "Category", in: self.manageContent!)!
        let category          = NSManagedObject(entity: categoryEntity, insertInto: manageContent)
        
        category.setValue(categoryDetail.name, forKey: "name")
        category.setValue(categoryDetail.budget, forKey: "budget")
        category.setValue(categoryDetail.colour, forKey: "colour")
        category.setValue(categoryDetail.tap, forKey: "tap")
        
        if categoryDetail.notes != "" {
            category.setValue(categoryDetail.notes, forKey: "notes")
        }
        
        do {
            try self.manageContent!.save()
            
            completion(true)
            
        } catch _ as NSError {
            
            completion(true)            
        }
    }
    
    
    func updateCategory(categoryDetail: CategoryData, categoryObj: NSManagedObject, completion: @escaping (Bool) -> Void) {
        
        let category  = categoryObj
        
        category.setValue(categoryDetail.name, forKey: "name")
        category.setValue(categoryDetail.budget, forKey: "budget")
        category.setValue(categoryDetail.colour, forKey: "colour")
        category.setValue(categoryDetail.tap, forKey: "tap")
        
        if categoryDetail.notes != "" {
            category.setValue(categoryDetail.notes, forKey: "notes")
        }
        
        do {
            try self.manageContent!.save()
            completion(true)
            
        } catch _ as NSError {
            completion(false)            
        }
    }
    
    func deleteCategory(categoryObj: NSManagedObject, completion: @escaping (Bool) -> Void) {
        
        do {
            self.manageContent!.delete(categoryObj)
            try self.manageContent!.save()
            completion(true)
            
        } catch _ as NSError {
            completion(false)
        }
        
    }
    
    func getCategoryList(order by: CategoryOrder) -> [NSManagedObject]  {
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        
        switch by {
        
        case .alphabetically:
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            let sortDescriptors = [sortDescriptor]
            fetch.sortDescriptors = sortDescriptors
        case .tap:
            let sortDescriptor = NSSortDescriptor(key: "tap", ascending: true)
            let sortDescriptors = [sortDescriptor]
            fetch.sortDescriptors = sortDescriptors
        }
        
        do {
            let result = try self.manageContent!.fetch(fetch)
            
            switch by {
            
            case .alphabetically:
                return (result as? [NSManagedObject] ?? [NSManagedObject]())
                
            case .tap:
                return (result as? [NSManagedObject] ?? [NSManagedObject]()).reversed()
                
            }
            
        } catch {
            
            print("Failed")
            return [NSManagedObject]()
        }
    }
    
    func getCategory(name: String) -> [Category]? {
        
        let fetchRequest : NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let result = try self.manageContent!.fetch(fetchRequest)
            
            return (result as [Category])
            
            
        } catch (let error){
            
            print("Error on category get: \(error.localizedDescription)")
            return nil
        }
    }
    
    //MARK: - Expenses Functions
    func saveExpense(amount: Decimal, note: String, dueDate: Date, addToCalendar:Bool, calendarId: String?, occur: Int, category: Category, completion: @escaping (Bool) -> Void) {
        
        let expenseEntity = NSEntityDescription.entity(forEntityName: "Expense", in: self.manageContent!)!
        let expense       = NSManagedObject(entity: expenseEntity, insertInto: manageContent)
        
        expense.setValue(note, forKey: "note")
        expense.setValue(amount, forKey: "amount")
        expense.setValue(dueDate, forKey: "date")
        expense.setValue(calendarId, forKey: "eventId")
        expense.setValue(occur, forKey: "occurrence")
        expense.setValue(addToCalendar, forKey: "reminder")
        
        category.addToExpenses(expense as! Expense)
        
        do {
            try self.manageContent!.save()
            
            completion(true)
            
        }  catch (let error){
            
            print("Error on expense save: \(error.localizedDescription)")
            completion(false)
            
        }
    }
    
    func deleteExpense(name: String, completion: @escaping (Bool) -> Void) {
        
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "note == %@", name)
        
        
        do {
            let result = try self.manageContent!.fetch(fetchRequest)
            
            if let expense = result.first {
                
                if let category = getCategory(name: (expense.category?.name)!)?.first{
                    
                    category.removeFromExpenses(expense)
                    self.manageContent!.delete(expense)
                    try self.manageContent!.save()
                    completion(true)
                } else {
                    completion(false)
                }
            }
            
            
        } catch (let error){
            
            print("Error on expense deletion: \(error.localizedDescription)")
            completion(false)
            
        }
    }
    
    func updateExpense(amount: Decimal, note: String, dueDate: Date, addToCalendar:Bool, calendarId: String?, occur: Int, oldExpenseName: String, category: Category, completion: @escaping (Bool) -> Void) {
        
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "note == %@", oldExpenseName)
                
        do {
            
            let result = try self.manageContent!.fetch(fetchRequest)
            
            if let expenseOld = result.first {
                
                category.removeFromExpenses(expenseOld)
                
                expenseOld.note       = note
                expenseOld.amount     = NSDecimalNumber(decimal: amount)
                expenseOld.date       = dueDate
                expenseOld.reminder   = addToCalendar
                expenseOld.occurrence = Int64(occur)
                expenseOld.eventId    = calendarId
                
                
                category.addToExpenses(expenseOld)
            }
            
            try self.manageContent!.save()
            completion(true)
            
        } catch _ as NSError {
            completion(false)
        }
       
    }
}
