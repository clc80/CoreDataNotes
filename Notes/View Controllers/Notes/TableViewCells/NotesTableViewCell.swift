//
//  NotesTableViewCell.swift
//  Notes
//
//  Created by claudia maciel on 9/30/21.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "NoteTableViewCell"
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentsLabel: UILabel!
    @IBOutlet var updatedAtLabel: UILabel!
    @IBOutlet var categoryColorView: UIView!
    @IBOutlet var tagsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
