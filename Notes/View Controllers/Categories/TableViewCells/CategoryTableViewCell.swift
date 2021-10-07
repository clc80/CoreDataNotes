//
//  CategoryTableViewCell.swift
//  Notes
//
//  Created by claudia maciel on 10/7/21.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    // MARK: - Properties
    static let reuseIdentifier = "CategoryTableViewCell"
    
    @IBOutlet var nameLabel: UILabel!
    
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
