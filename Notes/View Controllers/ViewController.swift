//
//  ViewController.swift
//  Notes
//
//  Created by claudia maciel on 9/21/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    private let coreDataManager = CoreDataManager(modelName: "Notes")

    override func viewDidLoad() {
        super.viewDidLoad()
        print(coreDataManager.managedObjectContext)
        
        let note = Note(context: coreDataManager.managedObjectContext)
        note.title = "My Second Note"
        note.createdAt = Date()
        note.updatedAt = Date()
        
        print(note.title ?? "No Title")
        
        do {
            try coreDataManager.managedObjectContext.save()
        } catch {
            print("Unable to save manged object context")
            print("\(error), \(error.localizedDescription)")
        }
        
        
        /// Old way of adding CoreData Entity
//        if let entityDescription = NSEntityDescription.entity(forEntityName: "Note", in: coreDataManager.managedObjectContext) {
//            print(entityDescription.name ?? "No Name")
//            print(entityDescription.properties)
//
//            let note = NSManagedObject(entity: entityDescription, insertInto: coreDataManager.managedObjectContext)
//
//            note.setValue("My first note", forKey: "title")
//            note.setValue(Date(), forKey: "createdAt")
//            note.setValue(Date(), forKey: "updatedAt")
//
//            print(note)
//
//            do {
//                try coreDataManager.managedObjectContext.save()
//            } catch {
//                print("Unable to save manged object context")
//                print("\(error), \(error.localizedDescription)")
//            }
//        }
    }


}

