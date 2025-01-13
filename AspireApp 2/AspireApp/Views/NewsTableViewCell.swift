//
//  NewsTableViewCell.swift
//  AspireApp
//
//  Created by Jacky Becker on 2024-12-08.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var TitleLabel: UILabel!
    
    
    @IBOutlet weak var LearnMore: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
