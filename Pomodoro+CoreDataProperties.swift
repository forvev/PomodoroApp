//
//  Pomodoro+CoreDataProperties.swift
//  LaboProjekt
//
//  Created by Artur Zelik on 14/06/2023.
//  Copyright © 2023 student. All rights reserved.
//
//

import Foundation
import CoreData


extension Pomodoro {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pomodoro> {
        return NSFetchRequest<Pomodoro>(entityName: "Pomodoro")
    }

    @NSManaged public var cycles: Int16
    @NSManaged public var goal: String?
    @NSManaged public var toBloom: Bloom?

}

extension Pomodoro : Identifiable {

}
