//
//  LandingProtocol.swift
//  NuerogleeApp
//
//  Created by User on 2/13/21.
//

import Foundation

protocol LandingViewToPresenterProtocol: BasePresenterProtocal{
    var totalScore:Int?{ get }
    var currentLevel:Int?{ get }
    func startGame()
    func showHistory()
    func showGameRules()
}

protocol LandingPresenterToViewProtocol: BaseViewProtocol{
    func refreshView()
}

protocol LandingPresenterToRouterProtocol: RouterProtocal {
    func pushToGameScreen()
    func pushToHistoryScreen()
}

protocol LandingPresenterToInteractorProtocol: BaseInteractorProtocol {
    var presenter:LandingInteractorToPresenterProtocol? {get set}
    func getGameScore()
}

protocol LandingInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func scoreResultData(data:Int, level:Int)
}
