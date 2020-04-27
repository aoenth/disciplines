//
//  Discipline+CoreDataProperties.swift
//  Disciplines
//
//  Created by Kevin Peng on 2020-04-25.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//
//

import Foundation
import CoreData


extension Discipline {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Discipline> {
        return NSFetchRequest<Discipline>(entityName: "Discipline")
    }

    @NSManaged public var dateIntroduced: Date
    @NSManaged public var isArchived: Bool
    @NSManaged public var order: Int64
    @NSManaged public var shortText: String
    @NSManaged public var completions: NSSet

}

// MARK: Generated accessors for completions
extension Discipline {

    @objc(addCompletionsObject:)
    @NSManaged public func addToCompletions(_ value: Completion)

    @objc(removeCompletionsObject:)
    @NSManaged public func removeFromCompletions(_ value: Completion)

    @objc(addCompletions:)
    @NSManaged public func addToCompletions(_ values: NSSet)

    @objc(removeCompletions:)
    @NSManaged public func removeFromCompletions(_ values: NSSet)

}
