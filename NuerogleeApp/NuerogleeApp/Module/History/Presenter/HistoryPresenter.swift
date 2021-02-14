//
//  HistoryPresenter.swift
//  NuerogleeApp
//
//  Created by User on 2/13/21.
//

import Foundation
import UIKit

class HistoryPresenter: HistoryViewToPresenterProtocol {

    private var _view: HistoryPresenterToViewProtocol?
    private var _interactor: HistoryPresenterToInteractorProtocol?
    private var _router: HistoryPresenterToRouterProtocol?

    var levels: [Level]? {
        didSet {
            _view?.refreshView()
        }
    }
    
    //MARK:- Initialization
    init(router: HistoryPresenterToRouterProtocol, view: HistoryPresenterToViewProtocol, interactor: HistoryPresenterToInteractorProtocol) {
        _view = view
        _router = router
        _interactor = interactor
    }

    //MARK:- Called when view will appear called from controller
    func viewDidLoad() {
        _interactor?.getAllLevels()
    }
    
    //MARK:- Navigation
    func moveToParentView() {
        _router?.dissmissView()
    }

    func showDetailView(for index:Int) {
        if let tempLevels = levels {
            _router?.gameDetailView(for: tempLevels[index])
        }
    }
}

//MARK:- Interactor to presenter Protocols
extension HistoryPresenter : HistoryInteractorToPresenterProtocol {
    func getLevelSuccess(levelsData: [Level]) {
        levels = levelsData
    }
    
    
   
}
