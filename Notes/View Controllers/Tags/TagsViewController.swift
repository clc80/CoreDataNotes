//
//  TagsViewController.swift
//  Notes
//
//  Created by claudia maciel on 10/15/21.
//

import UIKit
import CoreData

class TagsViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var note: Note?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Tag> = {
        guard let managedObjectContext = self.note?.managedObjectContext else {
            fatalError("No Managed Object Context Found")
        }
        
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Tag.name), ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: managedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    // MARK: - Segues
    private enum Segue {
        static let Tag = "Tag"
        static let AddTag = "AddTag"
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        title = "Tags"
        
        setupView()
        fetchTags()
        updateView()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Segue.AddTag:
            guard let destination = segue.destination as? AddTagViewController else { return }
            destination.managedObjectContext = note?.managedObjectContext
        case Segue.Tag:
            guard let destination = segue.destination as? TagViewController else { return }
            guard let cell = sender as? TagTableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            let tag = fetchedResultsController.object(at: indexPath)
            destination.tag = tag
        default:
            break
        }
    }
    
    // MARK: - ViewMethods
    
    private func setupView() {
        setupMessageLabel()
        setupBarButtonItems()
    }
    
    private func fetchTags() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to Perform Fetch Request")
            print("\(error), \(error.localizedDescription)")
        }
    }
    
    private func updateView() {
        var hasTags = false
        if let fetchedObjects = fetchedResultsController.fetchedObjects {
            hasTags = fetchedObjects.count > 0
        }
        tableView.isHidden = !hasTags
        messageLabel.isHidden = hasTags
    }
    
    private func setupMessageLabel() {
        messageLabel.text = "You don't have any tags yet."
    }
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(sender:)))
    }
    
    @objc private func add(sender: UIBarButtonItem) {
        performSegue(withIdentifier: Segue.AddTag, sender: self)
    }

}

extension TagsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:  TagTableViewCell.reuseIdentifier, for: indexPath) as? TagTableViewCell else {
            fatalError("Unexptected Index Path")
        }
        configure(cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let tag = fetchedResultsController.object(at: indexPath)
        note?.managedObjectContext?.delete(tag)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true )
        
        let tag = fetchedResultsController.object(at: indexPath)
        
        if let containsTags = note?.tags?.contains(tag), containsTags == true {
            note?.removeFromTags(tag)
        } else {
            note?.addToTags(tag)
        }
    }
    
    func configure(_ cell: TagTableViewCell, at indexPath: IndexPath) {
        let tag = fetchedResultsController.object(at: indexPath)
        cell.nameLabel.text = tag.name
        
        if let containsTags = note?.tags?.contains(tag), containsTags == true {
            cell.nameLabel.textColor = .purple
        } else {
            cell.nameLabel.textColor = .black
        }
    }
}

extension TagsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        updateView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? TagTableViewCell {
                configure(cell, at: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        }
    }
}
