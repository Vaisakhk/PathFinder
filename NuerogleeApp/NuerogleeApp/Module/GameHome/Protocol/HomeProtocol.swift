//
//  HomeProtocol.swift
//  NuerogleeApp
//
//  Created by User on 2/13/21.
//

import Foundation
import UIKit

protocol HomeViewToPresenterProtocol: BasePresenterProtocal{
    func startGame()
    func levelUp()
    func moveToLandingView()
    func startGameTimer()
    func restartGameTimer()
    func reStartCurrentGame()
//    var currentLevel:Int?{ get }
    var currentScore:Int?{ get }
    var boxConnections:[BoxView]? { get }
    var userConnections:[ConnectionView]? { get }
}

protocol HomePresenterToViewProtocol: BaseViewProtocol{
    func refreshView()
    func showTimerString(time:String, timeSeconds:Int)
    func placeBoxView(boxView: BoxView,for index:Int)
    func drawLinesBetweenBox()
    func moveToNextLevel()
    func updateScore()
    func addUserConnection(userView:ConnectionView,forIndex index:Int)
    func updateCurrentGameLevel(level:String)
}

protocol HomePresenterToRouterProtocol: RouterProtocal {
    func dissmissView()
    func showGameOverView(currentGameLevel:Level)
}

protocol HomePresenterToInteractorProtocol: BaseInteractorProtocol {
    var presenter:HomeInteractorToPresenterProtocol? {get set}
    var currentLevel:Int?{ get }
    func updateCurrentLevel(by value:Int)
    func gameHasBeenStarted()
    func gameHasBeenStopped()
    func startTimer()
    func restartTimer()
    func overlapped(movedConnection:ConnectionView,boxConnections: [BoxView], maxYValue:CGFloat)
    func levelClear(boxConnections: [BoxView]) -> Bool
    func isLevelClearForNextGame(boxConnections: [BoxView])
}

protocol HomeInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func timerResultData(seconds:Int,timeString:String)
    func scoreResultData(data:Int)
    func scoreResultCompletedWithSuccess(score:Int)
    func scoreResultCompletedWithError(errorString:String)
    func levelCompletedWithSuccess(for level:Level)
    func updateCurrentLevel()
}
