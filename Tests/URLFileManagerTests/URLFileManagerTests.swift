import XCTest
@testable import URLFileManager

final class URLFileManagerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(URLFileManager().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
