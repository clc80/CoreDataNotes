//
//  NoteViewController.swift
//  Notes
//
//  Created by claudia maciel on 9/30/21.
//

import UIKit
import CoreData

class NoteViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentsTextView: UITextView!
    @IBOutlet var categoryLabel: UILabel!
    
    var note: Note? 
    
    // MARK: - Segues
    private enum Segue {
        static let Categories = "Categories"
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Note"
        setupView()
        setupNotificationHandling()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let note = note else { return }
        
        if let title = titleTextField.text, !title.isEmpty && note.title != title {
            note.title = title
        }
        
        if note.contents != contentsTextView.text {
            note.contents = contentsTextView.text
        }
        
        if note.isUpdated {
            note.updatedAt = Date()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Segue.Categories:
            guard let destination = segue.destination as? CategoriesViewController else { return }
            destination.note = note
        default:
            break
        }
    }
    
    // MARK: - Helper Functions
    
    private func setupView() {
        setupTitleTextField()
        setupContentsTextView()
        setupCategoryLabel()
    }
    
    private func setupTitleTextField() {
        titleTextField.text = note?.title
    }
    
    private func setupContentsTextView() {
        contentsTextView.text = note?.contents
    }
    
    private func setupCategoryLabel() {
        updateCategoryLabel()
    }
    
    private func updateCategoryLabel() {
        categoryLabel.text = note?.category?.name ?? "No Category"
    }
    
    @objc private func managedObjectContextObjectsDidChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> else { return }
        
        if (updates.filter { return $0 == note}).count > 0 {
            updateCategoryLabel()
        }
    }
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChange(_:)),
                                       name: Notification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: note?.managedObjectContext)
    }

}
