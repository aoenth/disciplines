//
//  Discipline+CoreDataProperties.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-19.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//
//

import Foundation
import CoreData


extension Discipline {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Discipline> {
        return NSFetchRequest<Discipline>(entityName: "Discipline")
    }

    @NSManaged public var shortText: String
    @NSManaged public var dateIntroduced: Date
    @NSManaged public var isArchived: Bool

}
