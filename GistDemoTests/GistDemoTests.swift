//
//  GistDemoTests.swift
//  GistDemoTests
//
//  Created by Apple on 16/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import XCTest
@testable import GistDemo

class GistDemoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        let promise = expectation(description: "Get gist comments request test")
        let provider:GistCommentProvider = GistCommentProvider()
        provider.getGistComments(gistId: "d50e87b25637866b7c9daa9fdb3a7001", showProgress:true, successHandler: { (gistCommenttModel) in
            XCTAssertTrue((gistCommenttModel?.data?.count)! > 0, "Test success")
            promise.fulfill()
        }, errorHandler: { (error) in
            XCTAssertTrue(error.count == 0, "Error: \(error.description)")
            promise.fulfill()
        })
        
        self.waitForExpectations(timeout: 20, handler: { (error) in
            
        })
    }
    
}
