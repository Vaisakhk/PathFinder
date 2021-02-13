//
//  HomePresenter.swift
//  NuerogleeApp
//
//  Created by User on 2/13/21.
//

import Foundation

class HomePresenter: HomeViewToPresenterProtocol {
    
    private var _view: HomePresenterToViewProtocol?
    private var _interactor: HomePresenterToInteractorProtocol?
    private var _router: HomePresenterToRouterProtocol?
    
    //MARK:- Initialization
    init(router: HomePresenterToRouterProtocol, view: HomePresenterToViewProtocol, interactor: HomePresenterToInteractorProtocol) {
        _view = view
        _router = router
        _interactor = interactor
    }

    //MARK:- Called when view will appear called from controller
    func viewWillAppear(animated: Bool) {
        
    }
    
    //MARK:- To Start Game
    func startGame() {
        
    }
    
    func moveToLandingView() {
        _router?.dissmissView()
    }
}

//MARK:- Interactor to presenter Protocols
extension HomePresenter : HomeInteractorToPresenterProtocol {
    func scoreResultData(data: Int) {
        
    }
    
    func scoreResultCompletedWithSuccess(data: Int, index: Int) {
        
    }
    
    func scoreResultCompletedWithError(errorString: String) {
        
    }

}
