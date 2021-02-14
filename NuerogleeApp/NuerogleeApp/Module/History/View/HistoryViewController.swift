//
//  HistoryViewController.swift
//  NuerogleeApp
//
//  Created by User on 2/14/21.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyTableView: UITableView!
    var presenter: HistoryViewToPresenterProtocol?
    
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
        historyTableView.register(UINib(nibName: "HistoryHomeCell", bundle: nil), forCellReuseIdentifier: "cell")
        addBackBarButtonCustom()
    }
    
    //MARK:- UIView Action
    @IBAction func closeButtonAction(_ sender: Any) {
        presenter?.moveToParentView()
    }
    
    //MARK:- UIView Customization
    func addBackBarButtonCustom() {
        let barButton = UIBarButtonItem(image: UIImage(named: "backArrow"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.backButtonaction))
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    //MARK:- UIView Action
    @objc func backButtonaction() {
        presenter?.moveToParentView()
    }
    
}

extension HistoryViewController : HistoryPresenterToViewProtocol {
    func refreshView() {
        historyTableView.reloadData()
    }
}

extension HistoryViewController :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  presenter?.levels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? HistoryHomeCell, let level = presenter?.levels?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.populateData(data:level)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.showDetailView(for: indexPath.row)
    }
}
