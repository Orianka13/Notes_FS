//
//  StorageManager.swift
//  Notes_FS
//
//  Created by Олеся Егорова on 28.09.2021.
//

import UIKit
import CoreData

class StorageManager {
    
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }
    
    func deleteNote(note: Note) {
        let context = getContext()
        
        context.delete(note)
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func saveNote(withText text: String, font: String, fontSize: Double){
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Note", in: context) else { return }
        let noteObject = Note(entity: entity, insertInto: context)
        
        noteObject.text = text
        noteObject.font = font
        noteObject.fontSize = fontSize
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}
