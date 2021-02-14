//
//  HistoryInteractorTests.swift
//  NuerogleeAppTests
//
//  Created by User on 2/14/21.
//

import XCTest
@testable import NuerogleeApp
class HistoryInteractorTests: XCTestCase {
    var mockPresenter:FakeHistoryInteractionToPresenter?
    var sut :HistoryInteractor?
    
    override func setUpWithError() throws {
        mockPresenter = FakeHistoryInteractionToPresenter()
        sut = HistoryInteractor()
        sut?.presenter = mockPresenter
        
        let testLevel:Level = CoreDataHandler.sharedInstance.newEntityForName(entityName: "Level") as! Level
        testLevel.score = 1000
        testLevel.level = 1000
        testLevel.timeTaken = 10
        testLevel.isFinished = false
        CoreDataHandler.sharedInstance.saveContext()
    }

    override func tearDownWithError() throws {
        CoreDataHandler.sharedInstance.deleteAllDataWithCondition(name: "Level", predicate: NSPredicate(format: "(level ==  %@)", "\(1000)"))
    }
    
    func testGetAllLevels() {
        sut?.getAllLevels()
        XCTAssertEqual((mockPresenter?.fakeHistoryLevel?.count ?? 0)>0, true,"History is not empty")
        let lastLevel = mockPresenter?.fakeHistoryLevel?.last
        XCTAssertEqual(lastLevel?.level == 1000, true,"Last expected level is not correct")
    }

}

//MARK:- Mock up History interactor to presenter protocol
class FakeHistoryInteractionToPresenter: HistoryInteractorToPresenterProtocol {
    var fakeHistoryLevel:[Level]?
    func getLevelSuccess(levelsData: [Level]) {
        fakeHistoryLevel = levelsData
    }
    
}
