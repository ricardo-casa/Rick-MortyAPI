//
//  CharacterTableViewCell.swift
//  RickAndMorthy
//
//  Created by Ricardo Carrillo on 07/12/23.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {

    @IBOutlet weak var characterImageView: UIImageView!
    
    @IBOutlet weak var characterName: UILabel!
    
    @IBOutlet weak var characterId: UILabel!
    
    @IBOutlet weak var characterSpecies: UILabel!
    
    @IBOutlet weak var characterType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
