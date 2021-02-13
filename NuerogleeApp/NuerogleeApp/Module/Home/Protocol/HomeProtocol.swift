//
//  HomeProtocol.swift
//  NuerogleeApp
//
//  Created by User on 2/13/21.
//

import Foundation

protocol HomeViewToPresenterProtocol: BasePresenterProtocal{
    func startGame()
    func moveToLandingView()
    func startGameTimer()
    func restartGameTimer()
}

protocol HomePresenterToViewProtocol: BaseViewProtocol{
    func refreshView()
    func showTimerString(time:String, timeSeconds:Int)
}

protocol HomePresenterToRouterProtocol: RouterProtocal {
    func dissmissView()
}

protocol HomePresenterToInteractorProtocol: BaseInteractorProtocol {
    var presenter:HomeInteractorToPresenterProtocol? {get set}
    func getGameScore()
    func startTimer()
    func restartTimer()
}

protocol HomeInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func timerResultData(seconds:Int,timeString:String)
    func scoreResultData(data:Int)
    func scoreResultCompletedWithSuccess(data:Int,index:Int)
    func scoreResultCompletedWithError(errorString:String)
}
