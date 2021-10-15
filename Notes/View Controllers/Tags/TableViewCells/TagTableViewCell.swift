//
//  TagTableViewCell.swift
//  Notes
//
//  Created by claudia maciel on 10/15/21.
//

import UIKit

class TagTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "TagTableViewCell"
    
    @IBOutlet var nameLabel: UILabel!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()

    }
}
