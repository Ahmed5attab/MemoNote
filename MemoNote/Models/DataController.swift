//
//  File.swift
//  MemoNote
//
//  Created by Ahmed Khattab on 9/30/19.
//  Copyright © 2019 Ahmed Khattab. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let managedObjectContext: NSManagedObjectContext

    init(moc: NSManagedObjectContext) {
        self.managedObjectContext = moc
    }
    
    convenience init?() {
        
        guard let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd") else {
            return nil
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            return nil
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let persistantStoreFileURL = urls[0].appendingPathComponent("Notes.sqlite")
        
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistantStoreFileURL, options: nil)
        } catch {
            fatalError("Error adding store.")
        }
        
        self.init(moc: moc)
        
        
    }
    func saveNote(titel:String,note:String!,image:NSData!,Date:NSDate)
    {
        let newNote = NSEntityDescription.insertNewObject(forEntityName: "NoteData", into: self.managedObjectContext) as! NoteData
        newNote.titelData = titel
        
        newNote.noteTextData = note
       
        
        if let imageData = image
        {
            newNote.noteImageData = imageData
        }
        
        newNote.creatDate = Date
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Not Saved!")
        }
    }
    
}
