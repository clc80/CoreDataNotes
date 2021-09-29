//
//  ViewController.swift
//  Notes
//
//  Created by claudia maciel on 9/21/21.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {
    
    // MARK: - Properties
    
    private let coreDataManager = CoreDataManager(modelName: "Notes")

    
    // MARK: - Segues
    private enum Segue {
        static let AddNote = "AddNote"
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///newer way of adding CoreData Entity
//        let note = Note(context: coreDataManager.managedObjectContext)
//        note.title = "My Second Note"
//        note.createdAt = Date()
//        note.updatedAt = Date()
//
//        print(note.title ?? "No Title")
//
//        do {
//            try coreDataManager.managedObjectContext.save()
//        } catch {
//            print("Unable to save manged object context")
//            print("\(error), \(error.localizedDescription)")
//        }
        
        
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Segue.AddNote:
            guard let destination = segue.destination as? AddNoteViewController else {
                return
            }
            destination.managedObjectContext = coreDataManager.managedObjectContext
            
        default:
            break
        }
    }


}

