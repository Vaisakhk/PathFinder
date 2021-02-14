//
//  HistoryProtocol.swift
//  NuerogleeApp
//
//  Created by User on 2/13/21.
//

import Foundation
import UIKit

protocol HistoryViewToPresenterProtocol: BasePresenterProtocal{
    func moveToParentView()
    func showDetailView(for index:Int)
    var levels:[Level]? { get }
}

protocol HistoryPresenterToViewProtocol: BaseViewProtocol{
    func refreshView()
}

protocol HistoryPresenterToRouterProtocol: RouterProtocal {
    func dissmissView()
    func gameDetailView(for level:Level)
}

protocol HistoryPresenterToInteractorProtocol: BaseInteractorProtocol {
    var presenter:HistoryInteractorToPresenterProtocol? {get set}
    func getAllLevels()
}

protocol HistoryInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func getLevelSuccess(levelsData:[Level])
}
