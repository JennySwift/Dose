//
//  NumberTableViewCell.swift
//  Dose
//
//  Created by Jenny Swift on 22/12/18.
//  Copyright © 2018 Jenny Swift. All rights reserved.
//

import UIKit

class NumberTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var tableCellLabel: UILabel!
    @IBOutlet weak var tableCellTextField: UITextField!
    var name: String?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
