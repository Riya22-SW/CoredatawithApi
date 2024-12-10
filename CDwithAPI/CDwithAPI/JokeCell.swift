//
//  JokeCell.swift
//  CDwithAPI
//
//  Created by admin on 10/12/24.
//

import UIKit

class JokeCell: UITableViewCell {

    @IBOutlet weak var punchlinelbl: UILabel!
    @IBOutlet weak var setuplbl: UILabel!
    @IBOutlet weak var typelbl: UILabel!
    @IBOutlet weak var idlbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
