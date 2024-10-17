//
//  Favorite+CoreDataProperties.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 04/04/2023.
//
//

import Foundation
import CoreData

extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var idMovie: Int32
    @NSManaged public var isStar: Bool

}
