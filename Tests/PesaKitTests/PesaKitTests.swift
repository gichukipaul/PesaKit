import XCTest
@testable import PesaKit

final class PesaKitTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let config = PesaKitConfig(consumerKey: "test", consumerSecret: "test")
        PesaKit.configure(with: config)
        
        let stk = PesaKit.getInstance().stkPush()
        
        XCTAssertEqual(stk, "one")
    }
}
