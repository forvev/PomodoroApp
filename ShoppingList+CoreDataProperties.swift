//
//  ShoppingList+CoreDataProperties.swift
//  LaboProjekt
//
//  Created by student on 06/06/2022.
//  Copyright © 2022 student. All rights reserved.
//
//

import Foundation
import CoreData


extension ShoppingList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingList> {
        return NSFetchRequest<ShoppingList>(entityName: "ShoppingList")
    }

    @NSManaged public var title: String?
    @NSManaged public var items: NSSet?
    public var itemArray: [ShoppingItem] {
        let set = items as? Set<ShoppingItem> ?? []
        return set.sorted{
            $0.itemName! < $1.itemName!
        }
    }

}

// MARK: Generated accessors for items
extension ShoppingList {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ShoppingItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ShoppingItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
extension ShoppingList: Identifiable {
    
}
