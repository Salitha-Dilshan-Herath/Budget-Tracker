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
}
