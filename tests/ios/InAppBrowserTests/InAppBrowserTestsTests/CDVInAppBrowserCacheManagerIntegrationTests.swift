import Foundation
import XCTest
import WebKit
@testable import InAppBrowserTests

class CDVInAppBrowserCacheManagerIntegrationTests: XCTestCase {
    
    private var target: BrowserCacheManager?
    private var store: WKWebsiteDataStore?
    
    override func setUp() {
        let store = WKWebsiteDataStore.default()
        target = BrowserCacheManager(dataStore: store)
        self.store = store
    }
    
    func testDeleteCookies() {
        let expect = expectation(description: "Wait for cookie set finish")
        let validCookie = HTTPCookie.test()
        store?.httpCookieStore.setCookie(validCookie, completionHandler: {
            expect.fulfill()
        })
        
        waitForExpectations(timeout: 3.0, handler: nil)
        let expect2 = expectation(description: "Wait for get cookies")
        target?.deleteCache(completed: {
            self.store?.httpCookieStore.getAllCookies {
                XCTAssertTrue($0.isEmpty)
                expect2.fulfill()
            }
        })
        waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    func testDeleteSessionCookies() {
        let expect = expectation(description: "Wait for cookie set finish")
        let validCookie = HTTPCookie.test(name: "TestCookie1", sessionOnly: true)
        store?.httpCookieStore.setCookie(validCookie, completionHandler: { expect.fulfill() })
        waitForExpectations(timeout: 30.0, handler: nil)
        let expect2 = expectation(description: "Wait for get cookies")
        target?.deleteSessionCache(completed: {
            self.store?.httpCookieStore.getAllCookies {
                XCTAssertTrue($0.isEmpty)
                expect2.fulfill()
            }
        })
        waitForExpectations(timeout: 30.0, handler: nil)
    }
}

extension HTTPCookie {
    
    static func test(name: String = "TestCookie", sessionOnly: Bool = false) -> HTTPCookie {
        HTTPCookie(properties: [
            .name:  name,
            .value: "TestValue",
            .path: "TestPath\(sessionOnly)",
            .domain: "TestDomain\(sessionOnly)",
            .expires: Date().addingTimeInterval(10),
            .discard: sessionOnly
        ])!
    }
}
