//
//  HistoryDetailInteractorTests.swift
//  NuerogleeAppTests
//
//  Created by User on 2/14/21.
//

import XCTest
@testable import NuerogleeApp
class HistoryDetailInteractorTests: XCTestCase {
    var mockPresenter:FakeHistoryDetailInteractionToPresenter?
    var sut :HistoryDetailInteractor?
    
    override func setUpWithError() throws {
        mockPresenter = FakeHistoryDetailInteractionToPresenter()
        sut = HistoryDetailInteractor()
        sut?.presenter = mockPresenter

        let testLevel:Level = CoreDataHandler.sharedInstance.newEntityForName(entityName: "Level") as! Level
        testLevel.score = 1000
        testLevel.level = 1000
        testLevel.timeTaken = 10
        testLevel.isFinished = false
        let testScore:Score = CoreDataHandler.sharedInstance.newEntityForName(entityName: "Score") as! Score
        testScore.currentLevel = testLevel
        testScore.date = "14/02/2021 05:26:00"
        testScore.time = 2
        testScore.isPositiveMove = true
        testScore.score = 1
        testLevel.addToScores(testScore)
        CoreDataHandler.sharedInstance.saveContext()
    }

    override func tearDownWithError() throws {
        CoreDataHandler.sharedInstance.deleteAllDataWithCondition(name: "Level", predicate: NSPredicate(format: "(level ==  %@)", "\(1000)"))
    }

    /*
     * Test Get Score logic
     */
    func testGetScores() {
        let levelsArray:[Level] =  CoreDataHandler.sharedInstance.getAllDatasWithPredicate(entity: "Level", predicate: NSPredicate(format: "(level ==  %@)", "\(1000)"), sortDescriptor: nil) as? [Level] ?? []
        XCTAssertEqual(levelsArray.count>0 , true,"Level is not empty")
        sut?.getScores(from: levelsArray.first)
        XCTAssertEqual((mockPresenter?.fakeScores?.count ?? 0)>=1, true,"User didnt do any move")
        XCTAssertEqual(mockPresenter?.fakeScores?.first?.score == 1, true,"User score is not matching")
    }
}

//MARK:- Mock up Landing interactor to presenter protocol
class FakeHistoryDetailInteractionToPresenter: HistoryDetailInteractorToPresenterProtocol {
    var fakeScores:[Score]?
    func getScoreSuccess(scores: [Score]) {
        fakeScores = scores
    }
    
}
