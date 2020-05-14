//
//  YelpServiceTests.swift
//  FashionAroundMeTests
//
//  Created by John Clayton on 2020/5/14.
//  Copyright © 2020 John Clayton. All rights reserved.
//

import XCTest
import Moya
import RxMoya
import RxSwift
import CoreLocation

@testable import FashionAroundMe

class YelpServiceTests: XCTestCase {

	var provider: MoyaProvider<YelpService.BusinessesInterface>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

		provider = MoyaProvider<YelpService.BusinessesInterface>(stubClosure: MoyaProvider.immediatelyStub)

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }



    func testEmitsStubbedData() throws {
		var responseData: Data?

		let target: YelpService.BusinessesInterface = .search(near: CLLocation(), query: "coffee")
		_ = provider.rx.request(target).subscribe { event in
			switch event {
			case .success(let response):
				responseData = response.data
			case .error(let error):
				XCTFail("error: \(error)")
			}
		}
		XCTAssertEqual(responseData, target.sampleData)
    }

	func testMapsJSONDataCorrectly() {
		var receivedResponse: [YelpService.Businesses.Response.Business]?
		let expectation = XCTestExpectation(description: "Search businesses")
		let location = CLLocation(latitude: 37.7670169511878, longitude: -122.42184275)
		let service = YelpService.Businesses()
		_ = service.find(businessesNear: location, query: "coffee")
			.subscribe(onSuccess: { response in
				receivedResponse = response
				expectation.fulfill()
			}, onError: { error in
				XCTFail("error: \(error)")
			})
//		wait(for: [expectation], timeout: 10.0)
//		XCTAssertNotNil(receivedResponse)
	}


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
