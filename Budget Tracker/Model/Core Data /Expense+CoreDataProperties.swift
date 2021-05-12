//
//  Expense+CoreDataProperties.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-11.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amount: NSDecimalNumber?
    @NSManaged public var date: Date?
    @NSManaged public var occurrence: Int64
    @NSManaged public var note: String?
    @NSManaged public var reminder: Bool
    @NSManaged public var category: Category?

}

extension Expense : Identifiable {

}
