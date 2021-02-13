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
    
    func getGameScore() {
        
    }
}
