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

    @IBOutlet var notesView: UIView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var notes: [Note]? {
        didSet {
            updateView()
        }
    }
    
    private var hasNotes: Bool {
        guard let notes = notes else { return false }
        return notes.count > 0
    }
    
    // MARK: - Segues
    private enum Segue {
        static let AddNote = "AddNote"
        static let Note = "Note"
    }
    
    // MARK: -
    private let estimatedRowHeight = CGFloat(44.0)
    
    private lazy var updatedAtDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
        return dateFormatter
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        title =  "Notes"
        
        setupView()
        fetchNotes()
        setupNotificationHandling()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Segue.AddNote:
            guard let destination = segue.destination as? AddNoteViewController else { return }
            destination.managedObjectContext = coreDataManager.managedObjectContext
        case Segue.Note:
            guard let destination = segue.destination as? NoteViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow, let note = notes?[indexPath.row] else { return }
            destination.note = note
        default:
            break
        }
    }
    
    // MARK: - View Methods
    
    private func setupView() {
        setupMessageLabel()
        setupTableView()
    }
    
    private func updateView() {
        tableView.isHidden = !hasNotes
        messageLabel.isHidden = hasNotes
    }
    
    private func setupMessageLabel() {
        messageLabel.text = "You don't have any notes yet."
    }
    
    private func setupTableView() {
        tableView.isHidden = true
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func fetchNotes() {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Note.updatedAt), ascending: false)]
        
            do {
                let notes = try coreDataManager.managedObjectContext.fetch(fetchRequest)
                self.notes = notes
                self.tableView.reloadData()
            } catch {
                print("Unable to Execute Fetch Request")
                print("\(error), \(error.localizedDescription)")
            }
        }
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChange(_:)),
                                       name: Notification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: coreDataManager.managedObjectContext)
    }
    
    @objc private func managedObjectContextObjectsDidChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        var notesDidChange = false
        
        if let inserted = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            for insert in inserted {
                if let note = insert as? Note {
                    notes?.append(note)
                    notesDidChange = true
                }
            }
        }
        
        if let updated = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
            for update in updated {
                if let _ = update as? Note {
                    notesDidChange = true
                }
            }
        }
        
        if let deleted = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
            for delete in deleted {
                if let note = delete as? Note {
                    if let index = notes?.firstIndex(of: note) {
                        notes?.remove(at: index)
                        notesDidChange = true
                    }
                }
            }
        }
        
        if notesDidChange {
            notes?.sort(by: { $0.updatedAtAsDate > $1.updatedAtAsDate })
            tableView.reloadData()
            updateView()
        }
    }
}

extension NotesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return hasNotes ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let notes = notes else { return 0 }
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch Note
        guard let note = notes?[indexPath.row] else {
            fatalError("Unexpected Index Path")
        }
        
        // Dequeue Reusable Cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.reuseIdentifier, for: indexPath) as? NotesTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        cell.titleLabel.text = note.title
        cell.contentsLabel.text = note.contents
        cell.updatedAtLabel.text = updatedAtDateFormatter.string(from: note.updatedAtAsDate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        guard let note = notes?[indexPath.row] else {
            fatalError("Unexpected Index Path")
        }
        
        coreDataManager.managedObjectContext.delete(note)
        // This also works
        // note.managedObjectContext?.delete(note)
    }
}

