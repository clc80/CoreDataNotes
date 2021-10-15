//
//  TagViewController.swift
//  Notes
//
//  Created by claudia maciel on 10/15/21.
//

import UIKit

class TagViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet var nameTextField: UITextField!
    
    var tag: Tag?
    
    // MARK: - View Life Cyle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Tag"
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Update Tag
        if let name = nameTextField.text, !name.isEmpty {
            tag?.name = name
        }
    }

    // MARK: - View Methods
    private func setupView() {
        setupNameTextField()
    }
    
    private func setupNameTextField() {
        // Configure Name Text Field
        nameTextField.text = tag?.name
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
