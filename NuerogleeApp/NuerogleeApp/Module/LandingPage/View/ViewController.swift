//
//  ViewController.swift
//  NuerogleeApp
//
//  Created by User on 2/11/21.
//

import UIKit

class ViewController: UIViewController {
    var presenter: LandingViewToPresenterProtocol?
    @IBOutlet weak var gameRuleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    //MARK:- UIView Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.viewWillAppear(animated: animated)
    }
    
    //MARK:- UIView Action
    @IBAction func startButtonAction(_ sender: Any) {
        presenter?.startGame()
    }
    
}



//MARK:- Landing Presenter To view Protocol
extension ViewController : LandingPresenterToViewProtocol {
    func refreshView() {
        scoreLabel.text = "Total Score : " + "\(presenter?.totalScore ?? 0)"
    }
    
    
}
