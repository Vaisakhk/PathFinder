//
//  HistoryHomeCell.swift
//  NuerogleeApp
//
//  Created by User on 2/14/21.
//

import UIKit

class HistoryHomeCell: UITableViewCell {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeTakenLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(data:Level) {
        levelLabel.text = "\(data.level)"
        timeTakenLabel.text = "\(data.timeTaken)"
        scoreLabel.text = "\(data.score)"
        statusLabel.text = data.isFinished ? "Completed" : "InComplete"
        statusLabel.textColor = data.isFinished ? UIColor(named: "darkGreen") : UIColor.red
    }
}
