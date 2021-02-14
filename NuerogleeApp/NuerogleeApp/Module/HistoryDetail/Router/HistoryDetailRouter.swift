//
//  HistoryDetailRouter.swift
//  NuerogleeApp
//
//  Created by User on 2/13/21.
//

import Foundation
import UIKit

protocol HistoryDetailRouterDelegate {
    func backButtonClicked()
}

class HistoryDetailRouter: BaseRouter {
    var historyRouterDelegate:HistoryDetailRouterDelegate?
    
    init(levelModel:Level?) {
        let view = HistoryDetailViewController(nibName: "HistoryDetailViewController", bundle: nil)
        super.init(viewController: view)
        let interactor: HistoryDetailPresenterToInteractorProtocol = HistoryDetailInteractor()
        let router:HistoryDetailPresenterToRouterProtocol = self
        let presenter: HistoryDetailViewToPresenterProtocol & HistoryDetailInteractorToPresenterProtocol = HistoryDetailPresenter(router: router, view: view, interactor: interactor, currentLevelModel: levelModel)
        view.presenter = presenter
        interactor.presenter = presenter
    }
    
}

extension HistoryDetailRouter: HistoryDetailPresenterToRouterProtocol {
    func dissmissView() {
        viewController.dismiss(animated: true, completion: nil)
        if let clDelagate = historyRouterDelegate {
            clDelagate.backButtonClicked()
        }
    }
}
