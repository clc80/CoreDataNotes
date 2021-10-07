//
//  CategoryViewController.swift
//  Notes
//
//  Created by claudia maciel on 10/7/21.
//

import UIKit

class CategoryViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet var nameTextField: UITextField!
    
    var category: Category?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Category"
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Update Category
        if let name = nameTextField.text, !name.isEmpty {
            category?.name = name
        }
    }
    
    // MARK: - View Methods
    private func setupView() {
        setupNameTextField()
    }
    
    private func setupNameTextField() {
        nameTextField.text = category?.name
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
