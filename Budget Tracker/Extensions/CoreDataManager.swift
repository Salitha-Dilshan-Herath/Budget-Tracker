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
    
    func saveCategory(categoryDetail: CategoryData, vc: UIViewController) {
        
        
        let categoryEntity    = NSEntityDescription.entity(forEntityName: "Category", in: self.manageContent!)!
        let category          = NSManagedObject(entity: categoryEntity, insertInto: manageContent)
        
        category.setValue(categoryDetail.name, forKey: "name")
        category.setValue(categoryDetail.budget, forKey: "budget")
        category.setValue(categoryDetail.budget, forKey: "colour")
        
        if categoryDetail.notes != "" {
            category.setValue(categoryDetail.notes, forKey: "notes")
        }
        
        
        do {
            try self.manageContent!.save()
            Alert.showMessage(msg: "Project save successful", on: vc)
            
        } catch _ as NSError {
            
            Alert.showMessage(msg: "An error occured while saving the project", on: vc)
            
        }
    }
    
    func getCategoryList() -> [NSManagedObject]  {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        
        do {
            let result = try self.manageContent!.fetch(request)
            return result as? [NSManagedObject] ?? [NSManagedObject]()
            
        } catch {
            
            print("Failed")
            return [NSManagedObject]()
        }
        
         
    }
}
