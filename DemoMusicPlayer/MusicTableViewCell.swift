//
//  MusicTableViewCell.swift
//  DemoMusicPlayer
//
//  Created by SumitKumar on 20/07/18.
//  Copyright © 2018 SumitKumar. All rights reserved.
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
