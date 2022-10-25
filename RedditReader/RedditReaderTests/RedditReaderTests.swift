//
//  RedditReaderTests.swift
//  RedditReaderTests
//
//  Created by Victor on 25/10/22.
//

import XCTest
@testable import RedditReader

class RedditReaderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testURLRequestCreationSuccessfully() throws {
        let parameters = ["a":"1",
                          "b":"2"]
        let host = "https://testapi.com"
        let request = URLRequest(host, parameters: parameters, method: .get)
        let expectedURL = URL(string: "https://testapi.com?a=1&b=2")
        
        XCTAssertEqual(request.url,expectedURL)
    }
    
    func testListingDecodableResponseSuccessfully() throws {
        let decoder = JSONDecoder()
        if let url = Bundle(for: RedditReaderTests.self).url(forResource: "topRedditMock", withExtension: "json") {
            let data = try Data(contentsOf: url)
            let container = try decoder.decode(Listing.self, from: data)
            XCTAssertEqual(container.data.after, "t3_yccwhh")
        }
    }
    
    func testChildrenDecodableResponseSuccessfully() throws {
        let decoder = JSONDecoder()
        if let url = Bundle(for: RedditReaderTests.self).url(forResource: "topRedditMock", withExtension: "json") {
            let data = try Data(contentsOf: url)
            let container = try decoder.decode(Listing.self, from: data)
            XCTAssertEqual(container.data.children[0].data.title, "Metros in Iran today.")
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
