//
//  Notes.swift
//  Notes
//
//  Created by claudia maciel on 9/30/21.
//

import Foundation

extension Note {
    
    var updatedAtAsDate: Date {
        return updatedAt ?? Date()
    }
    
    var createdAtAsDate: Date {
        return createdAt ?? Date()
    }
}
