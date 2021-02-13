//
//  LandingProtocol.swift
//  NuerogleeApp
//
//  Created by User on 2/13/21.
//

import Foundation

protocol LandingViewToPresenterProtocol: BasePresenterProtocal{
    func startGame()
}

protocol LandingPresenterToViewProtocol: BaseViewProtocol{
    func refreshView()
}

protocol LandingPresenterToRouterProtocol: RouterProtocal {
    func pushToGameScreen()
}

protocol LandingPresenterToInteractorProtocol: BaseInteractorProtocol {
    var presenter:LandingInteractorToPresenterProtocol? {get set}
    func getGameScore()
}

protocol LandingInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func scoreResultData(data:Int)
    func scoreResultCompletedWithSuccess(data:Int,index:Int)
    func scoreResultCompletedWithError(errorString:String)
}
