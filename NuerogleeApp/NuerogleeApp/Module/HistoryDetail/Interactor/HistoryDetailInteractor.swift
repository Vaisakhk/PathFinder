//
//  HistoryDetailInteractor.swift
//  NuerogleeApp
//
//  Created by User on 2/13/21.
//

import Foundation
import UIKit

class HistoryDetailInteractor: HistoryDetailPresenterToInteractorProtocol {
    fileprivate var coreDataHandler  = CoreDataHandler.sharedInstance
    var presenter: HistoryDetailInteractorToPresenterProtocol?
    
    /*
     * Get all Scores for the current level
     *     Parameters :
     *          level    : Current Level that user playing currently
     *     Return     :
     *          Result returns to presenter
     */
    func getScores(from level:Level?) {
        var finalScore:[Score] = []
        if let tempLevel = level {
            if let scores:[Score] = tempLevel.scores?.allObjects as? [Score] {
                finalScore = scores
                finalScore.sort { (a, b) -> Bool in
                    (a.date ?? "") < (b.date ?? "")
                }
            }
            presenter?.getScoreSuccess(scores: finalScore)
        }
    }
}
