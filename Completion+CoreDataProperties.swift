//
//  Completion+CoreDataProperties.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-25.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//
//

import Foundation
import CoreData


extension Completion {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Completion> {
        return NSFetchRequest<Completion>(entityName: "Completion")
    }

    @NSManaged public var completionDate: Date
    @NSManaged public var discipline: Discipline

}
