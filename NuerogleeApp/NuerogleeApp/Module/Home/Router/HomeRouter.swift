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
        let presenter: HomeViewToPresenterProtocol & HomeInteractorToPresenterProtocol = HomePresenter(router: router, view: view, interactor: interactor)
        view.presenter = presenter
        interactor.presenter = presenter
    }
    
}

extension HomeRouter: HomePresenterToRouterProtocol {
    func dissmissView() {
        viewController.dismiss(animated: true, completion: nil)
    }
}
