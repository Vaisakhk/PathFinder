//
//  HomeInteractor.swift
//  NuerogleeApp
//
//  Created by User on 2/13/21.
//

import Foundation
import UIKit

class HomeInteractor: HomePresenterToInteractorProtocol {
    fileprivate var coreDataHandler  = CoreDataHandler.sharedInstance
    fileprivate var currentScore = 0
    fileprivate var currentLevelModel:Level?
    var presenter: HomeInteractorToPresenterProtocol?
    var timer = Timer()
    var seconds = 0
    var previousMoveTime = 5
    var isTimerRunning = false
    
    var currentLevel: Int? {
        didSet {
            presenter?.updateCurrentLevel()
        }
    }
    
    //MARK:- Game Start informed to Interactor
    /*
     * Game Start informed to Interactor
     */
    func gameHasBeenStarted() {
        currentLevel = getLastLevelPlayed()
        saveCurrentGameLevel()
    }
    
    /*
     * Game Stoped informed to Interactor
     */
    func gameHasBeenStopped() {
        currentLevel = 0
        currentScore = 0
        timer.invalidate()
    }
    
    //MARK:- Timer Functionality
    func startTimer() {
        restartTimer()
         timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    func restartTimer() {
        timer.invalidate()
        seconds = 0
        previousMoveTime = 5
        presenter?.timerResultData(seconds: seconds, timeString: "00:00:00")
    }
    
    @objc private func updateTimer() {
        seconds += 1
        presenter?.timerResultData(seconds: seconds, timeString: timeString(time: TimeInterval(seconds)) )
    }
    
    private func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    /*
     * Check whether Box and circles are overlapped
     *      Parameters :
     *        movedConnection: Dragged circle
     *        boxConnections : List of Box views displaying in UI
     *        maxYValue      : Maximum y value of the screen
     *      Returns :
     *        Result directly passed to presenter
     */
    func overlapped(movedConnection:ConnectionView,boxConnections: [BoxView], maxYValue:CGFloat) {
        for connection in boxConnections {
            if((movedConnection.frame.origin.x>=connection.frame.origin.x && movedConnection.frame.origin.x <= connection.frame.origin.x + connection.frame.width) && movedConnection.frame.origin.y>=connection.frame.origin.y && movedConnection.frame.origin.y <= connection.frame.origin.y + connection.frame.height) {
                if(movedConnection.tag == connection.tag) {
                    if(connection.connectedUser != nil && connection.connectedUser != movedConnection) {
                        movedConnection.frame = CGRect(origin: CGPoint(x:50*movedConnection.tag,y:Int(maxYValue)-140), size: CGSize(width: 44, height: 44))
                        connection.connectedUser = nil
                    }else {
                        let tempScore = connection.connectedUser == movedConnection ? 0 : 1
                        currentScore +=  tempScore
                        saveCurrentGameScore(isPositive: true, scoreValue: tempScore)
                        presenter?.scoreResultCompletedWithSuccess(score: currentScore)
                        connection.backgroundColor = .green
                        connection.connectedUser = movedConnection
                    }
                }else {
                    if(connection.connectedUser != nil && connection.connectedUser != movedConnection) {
                        movedConnection.frame = CGRect(origin: CGPoint(x:50*movedConnection.tag,y:Int(maxYValue)-140), size: CGSize(width: 44, height: 44))
                        if(connection.tag != connection.connectedUser?.tag){
                        connection.connectedUser = nil
                        }
                    }else {
                        currentScore -= 1
                        saveCurrentGameScore(isPositive: false, scoreValue: -1)
                        presenter?.scoreResultCompletedWithSuccess(score: currentScore)
                        connection.backgroundColor = .red
                        connection.connectedUser = nil
                        movedConnection.frame = CGRect(origin: CGPoint(x:50*movedConnection.tag,y:Int(maxYValue)-140), size: CGSize(width: 44, height: 44))
                    }
                }
            }else {
                if(connection.connectedUser  == nil) {
                    connection.backgroundColor = .blue
                }else if(connection.connectedUser  == movedConnection) {
                    currentScore -= 1
                    saveCurrentGameScore(isPositive: false, scoreValue: -1)
                    presenter?.scoreResultCompletedWithSuccess(score: currentScore)
                    connection.connectedUser  = nil
                    connection.backgroundColor = .blue
                    movedConnection.frame = CGRect(origin: CGPoint(x:50*movedConnection.tag,y:Int(maxYValue)-140), size: CGSize(width: 44, height: 44))
                }

            }
        }
    }
    
    /*
     * Check User moved all the boxes correctly
     *      Parameters :
     *        boxConnections : List of Box views displaying in UI
     *      Returns :
     *        Bool           : indicating whether user droped all numbers inside the box
     */
    func levelClear(boxConnections: [BoxView]) -> Bool {
        let isFinished = boxConnections.filter { (box) -> Bool in
            box.connectedUser != nil
        }.count == boxConnections.count

        return isFinished
    }
    
    /*
     * Check User moved all the boxes correctly and whether need to move to next game
     *      Parameters :
     *        boxConnections : List of Box views displaying in UI
     *      Return     :
     *        Result directly passed to presenter
     */
    func isLevelClearForNextGame(boxConnections: [BoxView]) {
        let isFinished = boxConnections.filter { (box) -> Bool in
            box.connectedUser != nil
        }.count == boxConnections.count
        if(isFinished) {
            currentLevelModel?.isFinished = true
            coreDataHandler.saveContext()
            if let currentModel = currentLevelModel {
                presenter?.levelCompletedWithSuccess(for: currentModel)
            }
        }
    }
    
    
    /*
     * To update current level if last level is finished, and save current score and level
     *      Parameters :
     *        value : Number to be incremented
     */
    func updateCurrentLevel(by value:Int) {
        if(getLastLevelIsFinished()) {
            currentLevel! += value
            currentScore = 0
            saveCurrentGameLevel()
            presenter?.scoreResultCompletedWithSuccess(score: currentScore)
        }
    }
    /*
     * TO save current Game Level
     */
    private func saveCurrentGameLevel() {
        let levelData:[Level] = coreDataHandler.getAllDatasWithPredicate(entity: "Level", predicate: NSPredicate(format: "(level ==  %@)", "\(currentLevel ?? 0)"), sortDescriptor: NSSortDescriptor(key: "level", ascending: true)) as? [Level] ?? []
        var level = levelData.first
        if (level == nil) {
            level  = coreDataHandler.newEntityForName(entityName: "Level") as? Level
        }else {
            //seconds = Int(level?.timeTaken ?? 0)
            //currentScore = Int(level?.score ?? 0)
            level?.removeFromScores(level?.scores ?? [])
        }
        level?.level = Int32(currentLevel ?? 0)
        level?.timeTaken = Int32(seconds)
        level?.score = Int32(currentScore)
        level?.isFinished = false
        currentLevelModel = level
        coreDataHandler.saveContext()
    }
    
    /*
     * TO save current score for each move under current level
     */
    private func saveCurrentGameScore(isPositive:Bool, scoreValue:Int) {
        let score  = coreDataHandler.newEntityForName(entityName: "Score") as? Score
        score?.currentLevel = currentLevelModel
        score?.time = Int32(seconds-previousMoveTime)
        score?.date = getDate()
        score?.isPositiveMove = isPositive
        score?.score = Int32(scoreValue)
        if let tempScrore = score {
            currentLevelModel?.addToScores(tempScrore)
            currentLevelModel?.timeTaken = Int32(seconds-5)
            currentLevelModel?.score = Int32(currentScore)
        }
        coreDataHandler.saveContext()
        previousMoveTime = seconds
    }
    
    /*
     * To Get last level playes
     *     Returns :
     *         Int    : returns last level unique number
     */
    private func getLastLevelPlayed() -> Int {
        let levelData:[Level] = coreDataHandler.getAllDatasWithPredicate(entity: "Level", predicate: nil, sortDescriptor: NSSortDescriptor(key: "level", ascending: true)) as? [Level] ?? []
        var levelValue = 1
        if levelData.count != 0 {
            if let tempLeaveData = levelData.last {
                let lastLevelPlayed = Int(tempLeaveData.level)
                levelValue = tempLeaveData.isFinished ? (lastLevelPlayed+1):lastLevelPlayed
            }
        }
        return levelValue
    }
    
    /*
     * To Check whether last level is finished or not
     *     Returns :
     *          Bool     : indicating last level is finished or not
     */
    private func getLastLevelIsFinished() -> Bool {
        let levelData:[Level] = coreDataHandler.getAllDatasWithPredicate(entity: "Level", predicate: nil, sortDescriptor: NSSortDescriptor(key: "level", ascending: true)) as? [Level] ?? []
        var isFinished = false
        if levelData.count != 0 {
            if let tempLeaveData = levelData.last {
                isFinished = tempLeaveData.isFinished
            }
        }
        return isFinished
    }
    
    /* TO Get current Date string
     * return :
            string      : Returns current date in dd/MM/yyyy hh:mm:ss format
     */
    private func getDate() -> String {
        let dateFormatter:DateFormatter = DateFormatter ()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        dateFormatter.calendar = NSCalendar(calendarIdentifier: .gregorian)! as Calendar
        return dateFormatter.string(from: Date())
    }
}
