//
//  HistoryTableViewCell.swift
//  NuerogleeApp
//
//  Created by User on 2/14/21.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeTakenLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func populateData(score:Score) {
        dateLabel.text = score.date ?? ""
        timeTakenLabel.text = "\(score.time )"
        scoreLabel.text = "\(score.score )"
        statusLabel.text = (score.isPositiveMove ? "Success" : "Failure")
        if(score.isPositiveMove) {
            scoreLabel.textColor = UIColor(named: "darkGreen")
            statusLabel.textColor = UIColor(named: "darkGreen")
        }else {
            scoreLabel.textColor = .red
            statusLabel.textColor = .red
        }
    }
}
