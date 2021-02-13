//
//  HomeProtocol.swift
//  NuerogleeApp
//
//  Created by User on 2/13/21.
//

import Foundation

protocol HomeViewToPresenterProtocol: BasePresenterProtocal{
    func startGame()
}

protocol HomePresenterToViewProtocol: BaseViewProtocol{
    func refreshView()
}

protocol HomePresenterToRouterProtocol: RouterProtocal {
    func dissmissView()
}

protocol HomePresenterToInteractorProtocol: BaseInteractorProtocol {
    var presenter:HomeInteractorToPresenterProtocol? {get set}
    func getGameScore()
}

protocol HomeInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func scoreResultData(data:Int)
    func scoreResultCompletedWithSuccess(data:Int,index:Int)
    func scoreResultCompletedWithError(errorString:String)
}
