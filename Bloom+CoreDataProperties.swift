//
//  Bloom+CoreDataProperties.swift
//  LaboProjekt
//
//  Created by Artur Zelik on 12/06/2023.
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
    //@NSManaged public var toPomodoro: Pomodoro?
    @NSManaged public var toBloom: NSSet?
    
    public var itemArray: [Bloom] {
        let set = toBloom as? Set<Bloom> ?? []
        return set.sorted{
            $0.stage < $1.stage
        }
    }
    

}

extension Bloom : Identifiable {

}
