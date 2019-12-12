//
//  PlayerMasterTableViewCell.swift
//  RUMBL
//
//  Created by ds-mayur on 12/12/19.
//  Copyright © 2019 Mayur Rathod. All rights reserved.
//

import UIKit

class PlayerMasterTableViewCell: UITableViewCell {

    @IBOutlet weak var playerView: PlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
