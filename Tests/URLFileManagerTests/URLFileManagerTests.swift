#if !os(watchOS)
import XCTest
@testable import URLFileManager

final class URLFileManagerTests: XCTestCase {

  let fm = URLFileManager.default

  func testExample() {
    let url = URL(fileURLWithPath: "abc.txt")
    let new = url.replacingPathExtension(with: "avi")
    XCTAssertEqual(new.lastPathComponent, "abc.avi")
  }
}
#endif
