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
        
    }
}
