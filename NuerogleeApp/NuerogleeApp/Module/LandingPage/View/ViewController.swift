//
//  ViewController.swift
//  NuerogleeApp
//
//  Created by User on 2/11/21.
//

import UIKit

class ViewController: UIViewController {
    var presenter: LandingViewToPresenterProtocol?
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    //MARK:- UIView Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nueroglee App"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.viewWillAppear(animated: animated)
    }
    
    //MARK:- UIView Action
    @IBAction func startButtonAction(_ sender: Any) {
        presenter?.startGame()
    }
    @IBAction func historyButtonAction(_ sender: Any) {
        presenter?.showHistory()
    }
    
    @IBAction func gameRuleButtonAction(_ sender: Any) {
        presenter?.showGameRules()
    }
}



//MARK:- Landing Presenter To view Protocol
extension ViewController : LandingPresenterToViewProtocol {
    func refreshView() {
        scoreLabel.text = "Total Score : " + "\(presenter?.totalScore ?? 0)"
        levelLabel.text = "Current Level : " + "\(presenter?.currentLevel ?? 0)"
    }
    
    
}
