//
//  HistoryDetailPresenter.swift
//  NuerogleeApp
//
//  Created by User on 2/13/21.
//

import Foundation
import UIKit

class HistoryDetailPresenter: HistoryDetailViewToPresenterProtocol {

    private var _view: HistoryDetailPresenterToViewProtocol?
    private var _interactor: HistoryDetailPresenterToInteractorProtocol?
    private var _router: HistoryDetailPresenterToRouterProtocol?

    var currentLevel: Level? {
        didSet {
            
        }
    }
    var currentScores: [Score]? {
        didSet {
            _view?.refreshView()
        }
    }
    
    //MARK:- Initialization
    init(router: HistoryDetailPresenterToRouterProtocol, view: HistoryDetailPresenterToViewProtocol, interactor: HistoryDetailPresenterToInteractorProtocol,currentLevelModel:Level?) {
        _view = view
        _router = router
        _interactor = interactor
        currentLevel = currentLevelModel
    }

    //MARK:- Called when view will appear called from controller
    func viewDidLoad() {
        _interactor?.getScores(from:currentLevel)
    }
    
    func moveToParentView() {
        _router?.dissmissView()
    }

}

//MARK:- Interactor to presenter Protocols
extension HistoryDetailPresenter : HistoryDetailInteractorToPresenterProtocol {
    func getScoreSuccess(scores: [Score]) {
        currentScores = scores
    }
    
   
}
