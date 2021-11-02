//
//  ContactViewCell.swift
//  ImageCaching
//
//  Created by Igor on 02.11.2021.
//

import UIKit

class ContactViewCell: UITableViewCell {

    @IBOutlet var imageViewForCell: CustomImageView!
    @IBOutlet var mainLabel: UILabel!
    
    static let cellID = "contactCell"
    
    static func nib() -> UINib {
        UINib(nibName: "ContactViewCell", bundle: nil)
        // nibName - name of class!
    }
    
    func configure(for contast: Contact) {
        mainLabel.text = contast.name.fullName
        imageViewForCell.fetchImage(from: contast.picture.large)
    }
}
