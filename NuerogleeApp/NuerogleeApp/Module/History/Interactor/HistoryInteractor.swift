//
//  HistoryInteractor.swift
//  NuerogleeApp
//
//  Created by User on 2/13/21.
//

import Foundation
import UIKit

class HistoryInteractor: HistoryPresenterToInteractorProtocol {
    fileprivate var coreDataHandler  = CoreDataHandler.sharedInstance
    var presenter: HistoryInteractorToPresenterProtocol?
    
    func getAllLevels() {
        let levelData:[Level] = coreDataHandler.getAllDatasWithPredicate(entity: "Level", predicate: nil, sortDescriptor: NSSortDescriptor(key: "level", ascending: true)) as? [Level] ?? []
        presenter?.getLevelSuccess(levelsData: levelData)
    }

}