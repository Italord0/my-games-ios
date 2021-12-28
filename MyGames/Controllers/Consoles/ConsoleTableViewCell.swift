//
//  ConsoleTableViewCell.swift
//  MyGames
//
//  Created by Aluno on 28/12/21.
//

import UIKit

class ConsoleTableViewCell: UITableViewCell {

    @IBOutlet weak var ivConsole: UIImageView!
    
    @IBOutlet weak var lblConsole: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(with console: Console) {
        lblConsole.text = console.name ?? ""
        if let image = console.image as? UIImage {
            ivConsole.image = image
        } else {
            ivConsole.image = UIImage(named: "noCover")
        }
    }
}
