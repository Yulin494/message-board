//
//  MainTableViewCell.swift
//  test0717
//
//  Created by imac-1681 on 2024/7/17.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet var lbText: UILabel!
    @IBOutlet var lbText2: UILabel!
    static let identifie = "MainTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
