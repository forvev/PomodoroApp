//
//  ShoppingItem+CoreDataProperties.swift
//  LaboProjekt
//
//  Created by student on 06/06/2022.
//  Copyright © 2022 student. All rights reserved.
//
//

import Foundation
import CoreData


extension ShoppingItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingItem> {
        return NSFetchRequest<ShoppingItem>(entityName: "ShoppingItem")
    }

    @NSManaged public var itemName: String?
    @NSManaged public var quantity: Int32

}
extension ShoppingItem: Identifiable {
    
}
