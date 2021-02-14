//
//  LandingInteractorTests.swift
//  NuerogleeAppTests
//
//  Created by User on 2/14/21.
//

import XCTest
@testable import NuerogleeApp

class LandingInteractorTests: XCTestCase {

    var mockPresenter:FakeLandingInteractionToPresenter?
    var sut :LandingInteractor?
    
    override func setUpWithError() throws {
        mockPresenter = FakeLandingInteractionToPresenter()
        sut = LandingInteractor()
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
    
    func testGetGameScore() {
        sut?.getGameScore()
        XCTAssertEqual(mockPresenter?.fakeLevel == 1000, true,"Incorrect Level returned expected 1000")
        XCTAssertEqual((mockPresenter?.fakeScoreResult ?? 0) > 1000, true,"Total score is not correct")
    }

}

//MARK:- Mock up Landing interactor to presenter protocol
class FakeLandingInteractionToPresenter: LandingInteractorToPresenterProtocol {
    var fakeLevel:Int?
    var fakeScoreResult:Int?
    
    func scoreResultData(data: Int, level: Int) {
        fakeLevel = level
        fakeScoreResult = data
    }
    
    func scoreResultCompletedWithSuccess(data: Int, index: Int) {
        
    }
    
    func scoreResultCompletedWithError(errorString: String) {
    
    }
    
}
