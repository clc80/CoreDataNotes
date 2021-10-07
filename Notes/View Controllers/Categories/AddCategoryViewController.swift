//
//  AddCategoryViewController.swift
//  Notes
//
//  Created by claudia maciel on 10/7/21.
//

import UIKit
import CoreData

class AddCategoryViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet var nameTextField: UITextField!
    
    var managedObjectContext: NSManagedObjectContext?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Category"
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Show Keyboard
        nameTextField.becomeFirstResponder()
    }
    
    
    // MARK: - View Methods
    private func setupView() {
        setupBarButtonItems()
    }
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save(sender:)))
    }
    
    @objc private func save(sender: UIBarButtonItem) {
        guard let managedObjectContext = managedObjectContext else { return }
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(with: "Name Missing", and: "Your category doesn't have a name.")
            return
        }
        
        // Create Category
        let category = Category(context: managedObjectContext)
        
        // Configure Category
        category.name = nameTextField.text
        
        // POP View Controller
        _ = navigationController?.popViewController(animated: true )
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
