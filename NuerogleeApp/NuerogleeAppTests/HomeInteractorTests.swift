//
//  HomeInteractorTests.swift
//  NuerogleeAppTests
//
//  Created by User on 2/14/21.
//

import XCTest
@testable import NuerogleeApp
class HomeInteractorTests: XCTestCase {
    var mockPresenter:FakeHomeInteractionToPresenter?
    var sut :HomeInteractor?
    
    override func setUpWithError() throws {
        mockPresenter = FakeHomeInteractionToPresenter()
        sut = HomeInteractor()
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
        sut?.gameHasBeenStopped()
    }

    /*
     * Test Game Start functionality
     */
    func testGameHasBeenStarted() {
        sut?.gameHasBeenStarted()
        XCTAssertEqual(sut?.currentLevel == 1000, true,"Incorrect Level returned expected 1000")
    }
    
    /*
     * Test All Scenarios after Game stop
     */
    func testGameHasBeenStopped() {
        sut?.gameHasBeenStopped()
        XCTAssertEqual(sut?.currentLevel == 0, true,"Incorrect Level returned expected 0")
        XCTAssertEqual(sut?.timer.isValid, false,"After Game stop also timer is running")
    }
    
    /*
     * Test Timer Functionality
     */
    func testStartTimer() {
        sut?.startTimer()
        XCTAssertNotNil( sut?.timer,"Timer Not started its Nil")
        XCTAssertNotNil(mockPresenter?.fakeSeconds,"Timer Not started seconds is Nil")
        XCTAssertNotNil( mockPresenter?.fakeTimeString,"Timer Not started time string value is Nil")
    }
    
    /*
     * Test Timer Asynchronously
     */
    func testStartTimerAsync() {
        sut?.startTimer()
        let promise = expectation(description: "Expecting Timer value greater than one")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            if((self?.mockPresenter?.fakeSeconds ?? 0) >= 1) {
               promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    /*
     * Test Function TImer Restart
     */
    func testRestartTimer() {
        sut?.restartTimer()
        XCTAssertEqual(sut?.seconds == 0, true,"Timer not restarted")
        XCTAssertEqual(mockPresenter?.fakeSeconds == 0, true,"Timer not restarted")
        XCTAssertEqual(mockPresenter?.fakeTimeString == "00:00:00", true,"Timer not restarted")
    }
    
    /*
     * Test Overlap Box
     */
    func testOverlapped() {
        let connectionVIew = ConnectionView(frame: CGRect.zero)
        connectionVIew.tag = 1000
        let box = BoxView(frame: CGRect.zero)
        box.tag = 1000
        let boxSecond = BoxView(frame: CGRect(x: 1000, y: 1000, width: 44, height: 44))
        boxSecond.tag = 1000
        sut?.overlapped(movedConnection: connectionVIew, boxConnections: [box,boxSecond], maxYValue: 480)
        XCTAssertEqual(mockPresenter?.fakeScore == 1, true,"Score not correct after user moved to correct box")
        XCTAssertEqual(box.backgroundColor == UIColor.green, true,"Matched Box Color is not Green")
        XCTAssertEqual(boxSecond.backgroundColor == UIColor.blue, true,"Ideal Box Color is not Blue")
    }
    
    /*
     * Test Test Level cleared logic
     */
    func testLevelClear() {
        let box = BoxView(frame: CGRect.zero)
        box.tag = 1000
        let boxSecond = BoxView(frame: CGRect(x: 1000, y: 1000, width: 44, height: 44))
        boxSecond.tag = 1000
       let restlt = sut?.levelClear(boxConnections: [box,boxSecond])
      XCTAssertEqual(restlt == false, true,"Level is cleared Already")
    }
    
    func testIsLevelClearForNextGame() {
        let connectionVIew = ConnectionView(frame: CGRect.zero)
        let box = BoxView(frame: CGRect.zero)
        box.tag = 1000
        box.connectedUser = connectionVIew
        let boxSecond = BoxView(frame: CGRect(x: 1000, y: 1000, width: 44, height: 44))
        boxSecond.tag = 1000
        sut?.isLevelClearForNextGame(boxConnections: [box,boxSecond])
        XCTAssertEqual((mockPresenter?.fakeCurrentLevel?.isFinished ?? false) == false, true,"Current Level is not finished since second box is empty")
        
    }
}

//MARK:- Mock up Home interactor to presenter protocol
class FakeHomeInteractionToPresenter: HomeInteractorToPresenterProtocol {
    var fakeSeconds:Int?
    var fakeScore:Int?
    var fakeTimeString:String?
    var fakeCurrentLevel:Level?
    func timerResultData(seconds: Int, timeString: String) {
        fakeSeconds = seconds
        fakeTimeString = timeString
    }
    
    func scoreResultData(data: Int) {
        
    }
    
    func scoreResultCompletedWithSuccess(score: Int) {
        fakeScore = score
    }
    
    func scoreResultCompletedWithError(errorString: String) {
        
    }
    
    func levelCompletedWithSuccess( for level: Level) {
        fakeCurrentLevel = level
    }
    
    func updateCurrentLevel() {
        
    }
    
    
}
