//
//  NoteData+CoreDataProperties.swift
//  MemoNote
//
//  Created by Ahmed Khattab on 9/30/19.
//  Copyright © 2019 Ahmed Khattab. All rights reserved.
//
//

import Foundation
import CoreData


extension NoteData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteData> {
        return NSFetchRequest<NoteData>(entityName: "NoteData")
    }

    @NSManaged public var titelData: String?
    @NSManaged public var noteTextData: String?
    @NSManaged public var creatDate: NSDate?
    @NSManaged public var noteImageData: NSData?

}
