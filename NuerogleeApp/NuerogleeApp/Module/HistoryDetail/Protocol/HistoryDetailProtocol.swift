//
//  HistoryDetailProtocol.swift
//  NuerogleeApp
//
//  Created by User on 2/13/21.
//

import Foundation
import UIKit

protocol HistoryDetailViewToPresenterProtocol: BasePresenterProtocal{
    func moveToParentView()
    var currentLevel:Level?{ get }
    var currentScores:[Score]? { get }
}

protocol HistoryDetailPresenterToViewProtocol: BaseViewProtocol{
    func refreshView()
}

protocol HistoryDetailPresenterToRouterProtocol: RouterProtocal {
    func dissmissView()
}

protocol HistoryDetailPresenterToInteractorProtocol: BaseInteractorProtocol {
    var presenter:HistoryDetailInteractorToPresenterProtocol? {get set}
    func getScores(from level:Level?)
}

protocol HistoryDetailInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func getScoreSuccess(scores:[Score])
}
