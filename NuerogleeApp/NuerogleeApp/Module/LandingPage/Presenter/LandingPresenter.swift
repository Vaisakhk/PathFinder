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
}

//MARK:- Interactor to presenter Protocols
extension LandingPresenter : LandingInteractorToPresenterProtocol {
    func scoreResultData(data: Int) {
        totalScore = data
    }
    
    func scoreResultCompletedWithSuccess(data: Int, index: Int) {
        
    }
    
    func scoreResultCompletedWithError(errorString: String) {
        
    }

}
