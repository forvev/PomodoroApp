//
//  Bloom+CoreDataProperties.swift
//  LaboProjekt
//
//  Created by Artur Zelik on 07/06/2023.
//  Copyright © 2023 student. All rights reserved.
//
//

import Foundation
import CoreData


extension Bloom {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bloom> {
        return NSFetchRequest<Bloom>(entityName: "Bloom")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var stage: Int16
    @NSManaged public var toPomodoro: Pomodoro?

}

extension Bloom : Identifiable {

}
