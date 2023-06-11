//
//  Pomodoro+CoreDataProperties.swift
//  LaboProjekt
//
//  Created by Artur Zelik on 07/06/2023.
//  Copyright © 2023 student. All rights reserved.
//
//

import Foundation
import CoreData


extension Pomodoro {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pomodoro> {
        return NSFetchRequest<Pomodoro>(entityName: "Pomodoro")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var time: Date?
    @NSManaged public var cycles: Int16
    @NSManaged public var toBloom: NSSet?
    public var itemArray: [Pomodoro] {
        let set = toBloom as? Set<Pomodoro> ?? []
        return set.sorted{
            $0.time! < $1.time!
        }
    }

}

extension Pomodoro : Identifiable {

}
