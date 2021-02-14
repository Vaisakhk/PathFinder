//
//  HistoryViewController.swift
//  NuerogleeApp
//
//  Created by User on 2/14/21.
//

import UIKit

class HistoryDetailViewController: UIViewController {

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var historyTableView: UITableView!
    var presenter: HistoryDetailViewToPresenterProtocol?
    
    @IBOutlet weak var congratsLabel: UILabel!
    //MARK:- UIView Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()

        customizeUI()
    }
    
    //MARK:- UIView Customization
    func customizeUI() {
        historyTableView.estimatedRowHeight = 150
        historyTableView.rowHeight = UITableView.automaticDimension
        historyTableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    //MARK:- UIView Action
    @IBAction func closeButtonAction(_ sender: Any) {
        presenter?.moveToParentView()
    }
    
}

extension HistoryDetailViewController : HistoryDetailPresenterToViewProtocol {
    func refreshView() {
        congratsLabel.text = "Congrats You Have Finished Level " + "\(presenter?.currentLevel?.level ?? 0)" + "\nYour Score " + "\(presenter?.currentLevel?.score ?? 0)"
//        levelLabel.text = "Level : " + "\(presenter?.currentLevel?.level ?? 0)"
//        scoreLabel.text = "Score : " + "\(presenter?.currentLevel?.score ?? 0)"
        historyTableView.reloadData()
    }
}

extension HistoryDetailViewController :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  presenter?.currentScores?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? HistoryTableViewCell, let currentScore = presenter?.currentScores?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.populateData(score:currentScore )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
