//
//  HomeRouter.swift
//  NuerogleeApp
//
//  Created by User on 2/13/21.
//

import Foundation
import UIKit

class HomeRouter: BaseRouter {
    init() {
        let view = HomeViewController(nibName: "HomeViewController", bundle: nil)
        super.init(viewController: UINavigationController(rootViewController: view))
        let interactor: HomePresenterToInteractorProtocol = HomeInteractor()
        let router:HomePresenterToRouterProtocol = self
        let presenter: HomeViewToPresenterProtocol & HomeInteractorToPresenterProtocol = HomePresenter(router: router, view: view, interactor: interactor, maxYValue: UIScreen.main.bounds.maxY)
        view.presenter = presenter
        interactor.presenter = presenter
    }
    
}

extension HomeRouter: HomePresenterToRouterProtocol {
    func dissmissView() {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func showGameOverView(currentGameLevel:Level) {
        let controller = HistoryDetailRouter(levelModel: currentGameLevel)
        controller.historyRouterDelegate = self
        viewController.presentRouter(controller, presentationStyle: .overCurrentContext)
    }
}

extension HomeRouter: HistoryDetailRouterDelegate {
    func backButtonClicked() {
        if let navigation:UINavigationController = viewController as? UINavigationController {
            if let homeView:HomeViewController = navigation.viewControllers.first as? HomeViewController {
                homeView.checkMove()
            }
        }
    }
}
