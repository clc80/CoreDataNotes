//
//  CategoryViewController.swift
//  Notes
//
//  Created by claudia maciel on 10/7/21.
//

import UIKit

class CategoryViewController: UIViewController {
    
    // MARK: - Segues
    private enum Segue {
        static let Color = "Color"
    }
    
    // MARK: - Properties
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var colorView: UIView!
    
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
    
    private func setupColorView() {
        // Configure Layer Color View
        colorView.layer.cornerRadius = CGFloat(colorView.frame.width / 2.0)
        updateColorView()
    }
    
    private func updateColorView() {
        colorView.backgroundColor = category?.color
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Segue.Color:
            guard let destination = segue.destination as? ColorViewController else { return }
            // Configure Destination
            destination.delegate = self
            destination.color = category?.color ?? .white
        default:
            break
        }
    }
}

extension CategoryViewController: ColorViewControllerDelegate {
    func controller(_ controller: ColorViewController, didPick color: UIColor) {
        category?.color = color
        updateColorView()
    }
}
