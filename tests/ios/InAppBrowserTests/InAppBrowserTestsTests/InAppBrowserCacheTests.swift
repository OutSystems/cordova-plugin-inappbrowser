import XCTest
@testable import InAppBrowserTests

class InAppBrowserCacheTests: XCTestCase {
    
    private var target: SafariBrowserPlugin?
    private var manager: StubCacheManager?
    
    override func setUp() {
        let manager = StubCacheManager()
        target = SafariBrowserPlugin(cacheManager: manager)
        self.manager = manager
    }

    func testShouldDeleteCacheOnly() throws {
        let validConfigurations = SafariBrowserConfigurations(clearCache: true)
        target?.setupCommonConfigurations(configurations: validConfigurations)
        XCTAssertTrue(manager?.didDeleteCache ?? false)
        XCTAssertFalse(manager?.didDeleteSessionCache ?? true)
        XCTAssertFalse(manager?.didClearData ?? true)
    }
    
    func testShouldDeleteSessionCacheOnly() throws {
        let validConfigurations = SafariBrowserConfigurations(clearSessionCache: true)
        target?.setupCommonConfigurations(configurations: validConfigurations)
        XCTAssertTrue(manager?.didDeleteSessionCache ?? false)
        XCTAssertFalse(manager?.didDeleteCache ?? true)
        XCTAssertFalse(manager?.didClearData ?? true)
    }
    
    func testShouldClearDataOnly() throws {
        let validConfigurations = SafariBrowserConfigurations(clearData: true)
        target?.setupCommonConfigurations(configurations: validConfigurations)
        XCTAssertTrue(manager?.didClearData ?? false)
        XCTAssertFalse(manager?.didDeleteSessionCache ?? true)
        XCTAssertFalse(manager?.didDeleteCache ?? true)
    }
}

class StubCacheManager: WebsiteCacheManager {
    
    var didDeleteCache = false
    var didDeleteSessionCache = false
    var didClearData = false
    
    func deleteCache(completed: (() -> ())?) {
        didDeleteCache = true
    }
    
    func deleteSessionCache(completed: (() -> ())?) {
        didDeleteSessionCache = true
    }
    
    func clearData() {
        didClearData = true
    }
}
