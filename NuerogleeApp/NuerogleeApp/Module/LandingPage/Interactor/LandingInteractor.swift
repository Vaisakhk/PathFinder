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
    
    func getGameScore() {
        let levelData:[Level] = coreDataHandler.getAllDatasWithPredicate(entity: "Level", predicate: nil, sortDescriptor: NSSortDescriptor(key: "level", ascending: true)) as? [Level] ?? []
      let totalScore =  levelData.reduce(0) { (sum, level) -> Int in
            sum + Int(level.score)
        }
        presenter?.scoreResultData(data: totalScore)
    }
}
