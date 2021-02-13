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
    var presenter: HomeInteractorToPresenterProtocol?
    var timer = Timer()
    var seconds = 60
    var isTimerRunning = false
    
    var currentLevel: Int? {
        didSet {

        }
    }
    
    //MARK:- Game Start informed to Interactor
    func gameHasBeenStarted() {
        currentLevel = 0
    }
    
    func gameHasBeenStopped() {
        currentLevel = 0
        currentScore = 0
        timer.invalidate()
    }
    //MARK:- Get total score
    func getGameScore() {
        
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
    
    @objc func updateTimer() {
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
                        currentScore +=  connection.connectedUser == movedConnection ? 0 : 1
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
    
    //MARK:- Change Current Level of the Game
    func updateCurrentLevel(by value:Int) {
        currentLevel! += value
    }
}
