//
//  HomePresenter.swift
//  NuerogleeApp
//
//  Created by User on 2/13/21.
//

import Foundation
import UIKit

class HomePresenter: HomeViewToPresenterProtocol {

    private var _view: HomePresenterToViewProtocol?
    private var _interactor: HomePresenterToInteractorProtocol?
    private var _router: HomePresenterToRouterProtocol?
    private var _maxYValue:CGFloat?
    private var currentSecond = 0

    var currentScore:Int?{
        didSet {
            _view?.updateScore()
        }
    }
    var boxConnections: [BoxView]? {
        didSet {

        }
    }
    
    var userConnections: [ConnectionView]? {
        didSet {

        }
    }
    
    //MARK:- Initialization
    init(router: HomePresenterToRouterProtocol, view: HomePresenterToViewProtocol, interactor: HomePresenterToInteractorProtocol,maxYValue: CGFloat) {
        _view = view
        _router = router
        _interactor = interactor
        _maxYValue = maxYValue
//        currentLevel = 0
        currentScore = 0
        boxConnections = []
        userConnections = []
    }

    //MARK:- Called when view will appear called from controller
    func viewWillAppear(animated: Bool) {
        //startGameTimer()
        _interactor?.gameHasBeenStarted()
        levelUp()
    }
    
    //MARK:- To Start Game
    func startGame() {
        
    }
    
    func moveToLandingView() {
        _interactor?.gameHasBeenStopped()
        _router?.dissmissView()
    }
    
    func startGameTimer() {
        _interactor?.startTimer()
    }
    
    func restartGameTimer() {
        _interactor?.restartTimer()
    }
    func reStartCurrentGame() {
        //currentLevel! -= 1
        _interactor?.updateCurrentLevel(by: -1)
        levelUp()
    }
    
    func levelUp() {
        startGameTimer()
        //currentLevel! += 1
        _interactor?.updateCurrentLevel(by: 1)
        boxConnections?.forEach { $0.removeFromSuperview() }
        boxConnections?.removeAll()
        userConnections?.forEach { $0.removeFromSuperview() }
        userConnections?.removeAll()
        let currentLevel = _interactor?.currentLevel ?? 0
        for i in 1...(currentLevel + 4 > 6 ? 6 : currentLevel + 4) {
            let boxConnection = BoxView(frame: CGRect(origin: .zero, size: CGSize(width: 80, height: 80)))
            boxConnection.tag = i
            boxConnections?.append(boxConnection)
        }
        
        guard let boxViewArray = boxConnections else {
            return
        }
        for i in 0 ..< boxViewArray.count {
            if i == boxViewArray.count - 1 {
                boxConnections?[i].after = boxConnections?[i]//connections[0]
            } else {
                boxConnections?[i].after = boxConnections?[i + 1]
            }
        }
        repeat {
            for i in 0..<boxViewArray.count {
                _view?.placeBoxView(boxView: boxConnections![i], for: i)
            }
        } while _interactor?.levelClear(boxConnections: boxConnections ?? []) ?? false
        _view?.drawLinesBetweenBox()
    }
    
    func loadUsers () {
        userConnections?.forEach { $0.removeFromSuperview() }
        userConnections?.removeAll()
        let currentLevel = _interactor?.currentLevel ?? 0
        for i in 1...(currentLevel + 4 > 6 ? 6 : currentLevel + 4) {
            let connection = ConnectionView(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
            connection.tag = i
            userConnections!.append(connection)
            _view?.addUserConnection(userView: connection, forIndex: i)
            connection.dragFinished = { [weak self] in
                if ((self?.currentSecond ?? 0) > 5) {
                    self?._interactor?.overlapped(movedConnection: connection, boxConnections: self?.boxConnections ?? [], maxYValue: self?._maxYValue ?? 0)
                    //self?.overlapped(movedConnection: connection)
                    self?._interactor?.isLevelClearForNextGame(boxConnections: self?.boxConnections ?? [])
//                    if (self?._interactor?.levelClear(boxConnections: self?.boxConnections ?? []) ?? false) {
//                        self?._view?.moveToNextLevel()
//                    }
                }else {
                    
                }
            }
        }
    }
}

//MARK:- Interactor to presenter Protocols
extension HomePresenter : HomeInteractorToPresenterProtocol {
    func timerResultData(seconds: Int, timeString: String) {
        currentSecond = seconds
        _view?.showTimerString(time: timeString, timeSeconds: seconds)
        if(seconds == 5) {
            (boxConnections ?? []).forEach { $0.nameLabel.isHidden = true}
            loadUsers()
        }
    }
    
    func scoreResultData(data: Int) {
        
    }
    
    func scoreResultCompletedWithSuccess(score: Int) {
        currentScore = score
    }
    
    func scoreResultCompletedWithError(errorString: String) {
        
    }

    func levelCompletedWithSuccess(message: String) {
        _router?.showAlertPopup(with: message, title: AlertConstants.alertTitle, successButtonTitle: AlertConstants.closeButtonTitle, successBlock: {[weak self] (isSuccess) in
            self?._view?.moveToNextLevel()
        })
    }
    
    func updateCurrentLevel() {
        _view?.updateCurrentGameLevel(level: "\(_interactor?.currentLevel ?? 0)")
    }
}
