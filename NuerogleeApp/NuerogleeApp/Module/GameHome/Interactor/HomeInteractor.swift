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
    var previousMoveTime = 0
    var isTimerRunning = false
    
    var currentLevel: Int? {
        didSet {
            presenter?.updateCurrentLevel()
        }
    }
    
    //MARK:- Game Start informed to Interactor
    func gameHasBeenStarted() {
        currentLevel = getLastLevelPlayed()
        saveCurrentGameLevel()
    }
    
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
    
    //MARK:- Check whether user placed circle correctly in Box
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
    
    //MARK:- Check User moved all the boxes correctly
    func levelClear(boxConnections: [BoxView]) -> Bool {
        let isFinished = boxConnections.filter { (box) -> Bool in
            box.connectedUser != nil
        }.count == boxConnections.count

        return isFinished
    }
    
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
    
    
    //MARK:- Change Current Level of the Game
    func updateCurrentLevel(by value:Int) {
        if(getLastLevelIsFinished()) {
            currentLevel! += value
            currentScore = 0
            saveCurrentGameLevel()
            presenter?.scoreResultCompletedWithSuccess(score: currentScore)
        }
    }
    
//    private func getFinishedMessage() ->String {
//        var message = ""
//        message = message + "Congratss Completed " + "\(currentLevel ?? 0)" + " Level\n"
//        message = message + "Your Score is " + "\(currentLevelModel?.score ?? 0)" + "\n"
//        message = message + "Total time Taken for this level " + timeString(time: TimeInterval(currentLevelModel?.timeTaken ?? 0))
//        message = message + "\n Your Movements \n\n"
//        if let scores:[Score] = currentLevelModel?.scores?.allObjects as? [Score] {
//            var tempScore = scores
//            tempScore.sort { (a, b) -> Bool in
//                a.date! < b.date!
//            }
//            for score in tempScore {
//                message = message + "Date "+(score.date ?? "") + "\n"
//                message = message + "Time Taken "+"\(score.time )" + "\n"
//                message = message + "score "+"\(score.score )" + "\n"
//                message = message + (score.isPositiveMove ? " This Move is Success" : "This Move is Failure") + "\n"
//            }
//        }
//        return message
//    }
    
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
    
    private func saveCurrentGameScore(isPositive:Bool, scoreValue:Int) {
        let score  = coreDataHandler.newEntityForName(entityName: "Score") as? Score
        score?.currentLevel = currentLevelModel
        score?.time = Int32(seconds-previousMoveTime)
        score?.date = getDate()
        score?.isPositiveMove = isPositive
        score?.score = Int32(scoreValue)
        if let tempScrore = score {
            currentLevelModel?.addToScores(tempScrore)
            currentLevelModel?.timeTaken = Int32(seconds)
            currentLevelModel?.score = Int32(currentScore)
        }
        coreDataHandler.saveContext()
        previousMoveTime = seconds
    }
    
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
