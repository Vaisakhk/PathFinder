//
//  LandingRouter.swift
//  NuerogleeApp
//
//  Created by User on 2/13/21.
//

import Foundation

import UIKit

final class LandingRouter: BaseRouter {
    init() {
        let view = UIStoryboard(name:"Main",bundle: Bundle.main).instantiateViewController(withIdentifier: "viewController") as! ViewController
        super.init(viewController: view)
        let interactor: LandingPresenterToInteractorProtocol = LandingInteractor()
        let router:LandingPresenterToRouterProtocol = self
        let presenter: LandingViewToPresenterProtocol & LandingInteractorToPresenterProtocol = LandingPresenter(router: router, view: view, interactor: interactor)
      
        view.presenter = presenter
        interactor.presenter = presenter
    }
    
    //MARK:- Navigate to Friends list
    private func navigateToGameScreen() {
        viewController.presentRouter(HomeRouter(), presentationStyle: .fullScreen)
        //navigationController?.pushRouter(HomeRouter())
    }
    
    private func navigateToHistoryScreen() {
        viewController.presentRouter(HistoryRouter(), presentationStyle: .fullScreen)
        //navigationController?.pushRouter(HomeRouter())
    }
}

//MARK:- Landing Presenter To Router Protocol
extension LandingRouter: LandingPresenterToRouterProtocol {
    func pushToHistoryScreen() {
        navigateToHistoryScreen()
    }
    
    func pushToGameScreen() {
        navigateToGameScreen()
    }
    
    
}
