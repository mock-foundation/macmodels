import XCTest
@testable import MacModels

final class MacModelsTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let devices = MacModels.getAllModels().first(where: { $0.name == "Mac Mini"})?.devices
        print(MacModels.getAllModels())
        XCTAssertNotNil(devices)
        let emptyModels: [Device] = []
        XCTAssertNotEqual(devices!, emptyModels)
    }
}
