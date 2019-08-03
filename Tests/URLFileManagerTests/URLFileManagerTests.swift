#if !os(watchOS)
import XCTest
@testable import URLFileManager

final class URLFileManagerTests: XCTestCase {
    func testExample() {
        let url = URL(fileURLWithPath: "abc.txt")
        let new = url.replacingPathExtension(with: "avi")
        XCTAssertEqual(new.lastPathComponent, "abc.avi")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
#endif
