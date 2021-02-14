//
//  LandingInteractor.swift
//  NuerogleeApp
//
//  Created by User on 2/13/21.
//

import Foundation

class LandingInteractor: LandingPresenterToInteractorProtocol {
    fileprivate var coreDataHandler  = CoreDataHandler.sharedInstance
    var presenter: LandingInteractorToPresenterProtocol?
    
    /*
     * Get Total Game Score, After getting the scrore informed to presenter
     */
    func getGameScore() {
        let levelData:[Level] = coreDataHandler.getAllDatasWithPredicate(entity: "Level", predicate: nil, sortDescriptor: NSSortDescriptor(key: "level", ascending: true)) as? [Level] ?? []
      let totalScore =  levelData.reduce(0) { (sum, level) -> Int in
            sum + Int(level.score)
        }
        
        var levelValue = 0
        if levelData.count != 0 {
            if let tempLeaveData = levelData.last {
                levelValue = Int(tempLeaveData.level)
            }
        }
        presenter?.scoreResultData(data: totalScore, level: levelValue)
    }
}
