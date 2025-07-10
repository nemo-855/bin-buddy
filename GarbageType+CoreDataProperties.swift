//
//  GarbageType+CoreDataProperties.swift
//  BinBuddy
//
//  Created by Kohei Inoue on 2025/07/10.
//
//

import Foundation
import CoreData


extension GarbageType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GarbageType> {
        return NSFetchRequest<GarbageType>(entityName: "GarbageType")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var daysOfWeek: NSObject?

}

extension GarbageType : Identifiable {

}
