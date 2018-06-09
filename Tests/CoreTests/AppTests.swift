import XCTest
@testable import Core

final class AppTests: XCTestCase {

  func testAppInitialisation() {
      let arguments = ["--option1", "-a", "moo", "help"]
      let app = App(arguments: arguments)

      XCTAssertEqual(app.arguments.count, 4)
      XCTAssertEqual(app.arguments[0], "--option1")
      XCTAssertEqual(app.arguments[1], "-a")
      XCTAssertEqual(app.arguments[2], "moo")
      XCTAssertEqual(app.arguments[3], "help")
  }

}
