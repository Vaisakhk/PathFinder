//
//  HistoryRouter.swift
//  NuerogleeApp
//
//  Created by User on 2/13/21.
//

import Foundation
import UIKit

class HistoryRouter: BaseRouter {
    
    init() {
        let view = HistoryViewController(nibName: "HistoryViewController", bundle: nil)
        super.init(viewController: UINavigationController(rootViewController: view))
        let interactor: HistoryPresenterToInteractorProtocol = HistoryInteractor()
        let router:HistoryPresenterToRouterProtocol = self
        let presenter: HistoryViewToPresenterProtocol & HistoryInteractorToPresenterProtocol = HistoryPresenter(router: router, view: view, interactor: interactor)
        view.presenter = presenter
        interactor.presenter = presenter
    }
    
}

extension HistoryRouter: HistoryPresenterToRouterProtocol {
    func dissmissView() {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func gameDetailView(for level:Level) {
        let controller = HistoryDetailRouter(levelModel: level)
        viewController.presentRouter(controller, presentationStyle: .overCurrentContext)
    }
}
