//
//  StarsAndForksTableViewCell.swift
//  effectiveTest
//
//  Created by Вениамин Китченко on 05.07.2020.
//  Copyright © 2020 Вениамин Китченко. All rights reserved.
//

import UIKit

class StarsAndForksTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var stairsAndForksLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
