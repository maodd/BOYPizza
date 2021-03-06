//
//  RepositoryTests.swift
//  Build Your Own pizzas
//
//  Created by Frank Mao on 2016-12-09.
//  Copyright © 2016 mazoic. All rights reserved.
//

import XCTest
@testable import BYOPizza

class RepositoryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParseSampleData() {
     
        let orders = Repository.sharedInstance.parseSampleData()
        
        XCTAssertEqual(12761, orders.count)
    }
    
    func testMakeConfigurationNameFrom() {
        
        let cfgName = Repository.sharedInstance.makeConfigurationNameFrom(toppings: ["a","C","b"])
        
        XCTAssertEqual("a,b,c", cfgName)
    }
    
}
