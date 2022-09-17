//
//  Conversation+CoreDataProperties.swift
//  ChatBot
//
//  Created by vishalthakur on 17/09/22.
//
//

import Foundation
import CoreData


extension Conversation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Conversation> {
        return NSFetchRequest<Conversation>(entityName: "Conversation")
    }

    @NSManaged public var displayName: String?
    @NSManaged public var id: String?
    @NSManaged public var message: String?

}

extension Conversation : Identifiable {

}
