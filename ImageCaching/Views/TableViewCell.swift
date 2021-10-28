//
//  TableViewCell.swift
//  ImageCaching
//
//  Created by Igor on 28.10.2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var imageViewForCell: CustomImageView!
    @IBOutlet var mainLabel: UILabel!
    
    func configure(for contast: Contact) {
        mainLabel.text = contast.name.fullName
        imageViewForCell.fetchImage(from: contast.picture.large)
    }
}
