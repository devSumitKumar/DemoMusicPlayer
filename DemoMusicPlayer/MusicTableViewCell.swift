//
//  MusicTableViewCell.swift
//  DemoMusicPlayer
//
//  Created by Polosoft on 20/07/18.
//  Copyright © 2018 Polosoft. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnInfo: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData(_ data : Any)  {
        
        
        
    }

}
