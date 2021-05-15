//
//  Category+CoreDataProperties.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-11.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var budget: NSDecimalNumber?
    @NSManaged public var notes: String?
    @NSManaged public var colour: Int64
    @NSManaged public var expenses: NSSet?
    @NSManaged public var tap: Int64


}

// MARK: Generated accessors for expenses
extension Category {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: Expense)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: Expense)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}

extension Category : Identifiable {

}
