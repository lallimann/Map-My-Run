//
//  ProgressTableViewCell.swift
//  MapMyRun
//
//  Created by Lalli Mann on 18/03/18.
//  Copyright © 2018 c0727815. All rights reserved.
//

import UIKit

class ProgressTableViewCell: UITableViewCell {

    @IBOutlet weak var progressImage: UIImageView!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
