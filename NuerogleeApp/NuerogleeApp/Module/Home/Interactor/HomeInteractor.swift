//
//  HomeInteractor.swift
//  NuerogleeApp
//
//  Created by User on 2/13/21.
//

import Foundation

class HomeInteractor: HomePresenterToInteractorProtocol {
    fileprivate var coreDataHandler  = CoreDataHandler.sharedInstance
    var presenter: HomeInteractorToPresenterProtocol?
    
    var timer = Timer()
    var seconds = 60
    var isTimerRunning = false
    
    //MARK:- Get total score
    func getGameScore() {
        
    }
    
    func startTimer() {
        runTimer()
    }
    
    func restartTimer() {
        resetTimer()
    }
    
    func runTimer() {
        resetTimer()
         timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds += 1     //This will decrement(count down)the seconds.
//        timeLabel.text = timeString(time: TimeInterval(seconds)) //This will update the label.
        presenter?.timerResultData(seconds: seconds, timeString: timeString(time: TimeInterval(seconds)) )
//        if(seconds == 5) {
//            boxConnections.forEach { $0.nameLabel.isHidden = true}
//            loadUsers()
//        }
    }
    
    func resetTimer() {
        timer.invalidate()
        seconds = 0
//        timeLabel.text = "00:00:00"
        presenter?.timerResultData(seconds: seconds, timeString: "00:00:00")
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}
