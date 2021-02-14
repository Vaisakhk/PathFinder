//
//  LandingPresenter.swift
//  NuerogleeApp
//
//  Created by User on 2/13/21.
//

import Foundation


class LandingPresenter: LandingViewToPresenterProtocol {
    
    private var _view: LandingPresenterToViewProtocol?
    private var _interactor: LandingPresenterToInteractorProtocol?
    private var _router: LandingPresenterToRouterProtocol?
    var totalScore:Int?{
        didSet {
            _view?.refreshView()
        }
    }
    
    var currentLevel:Int?{
        didSet {
        }
    }
    //MARK:- Initialization
    init(router: LandingPresenterToRouterProtocol, view: LandingPresenterToViewProtocol, interactor: LandingPresenterToInteractorProtocol) {
        _view = view
        _router = router
        _interactor = interactor
    }

    //MARK:- Called when view will appear called from controller
    func viewWillAppear(animated: Bool) {
        _interactor?.getGameScore()
    }
    
    //MARK:- To Start Game
    func startGame() {
        _router?.pushToGameScreen()
    }
    func showHistory() {
        _router?.pushToHistoryScreen()
    }
    func showGameRules() {
        let message = "Once game started all the Boxes in the screen represent users, and all the covid connections will be represented by lines, and numbers will also display in the box to indicate the order of contact tracing.\n After 5 seconds Numbers will be dissappear from the Box, and numbers will be displayed on bottom of the screen.\nUsers need to place(drag and drop) each number correctly in the box. Each positive move have 1 point and each negative move have -1 point"
        _router?.showAlertPopup(with:message, title:  "Game Rules", successButtonTitle: AlertConstants.closeButtonTitle)
    }
}

//MARK:- Interactor to presenter Protocols
extension LandingPresenter : LandingInteractorToPresenterProtocol {
    func scoreResultData(data: Int, level: Int) {
        currentLevel = level
        totalScore = data
    }
}
