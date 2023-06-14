//
//  Bloom+CoreDataProperties.swift
//  LaboProjekt
//
//  Created by Artur Zelik on 14/06/2023.
//  Copyright © 2023 student. All rights reserved.
//
//

import Foundation
import CoreData


extension Bloom {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bloom> {
        return NSFetchRequest<Bloom>(entityName: "Bloom")
    }

    @NSManaged public var stage: String?
    //@NSManaged public var toPomodoro: NSSet?
    @NSManaged public var toPomodoro: NSSet?

    public var pomodoroArray: [Pomodoro] {
        let set = toPomodoro as? Set<Pomodoro> ?? []
        return set.sorted{
            $0.cycles < $1.cycles
        }
    }

}

// MARK: Generated accessors for toPomodoro
extension Bloom {

    @objc(addToPomodoroObject:)
    @NSManaged public func addToToPomodoro(_ value: Pomodoro)

    @objc(removeToPomodoroObject:)
    @NSManaged public func removeFromToPomodoro(_ value: Pomodoro)

    @objc(addToPomodoro:)
    @NSManaged public func addToToPomodoro(_ values: NSSet)

    @objc(removeToPomodoro:)
    @NSManaged public func removeFromToPomodoro(_ values: NSSet)

}

extension Bloom : Identifiable {

}
