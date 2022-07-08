import XCTest
@testable import MacModels

final class MacModelsTests: XCTestCase {
    func testAllDevices() throws {
        let devices = MacModels.getAllDevices().first(where: { $0.name == "Mac Mini"})?.devices
        XCTAssertNotNil(devices)
        let emptyModels: [Device] = []
        XCTAssertNotEqual(devices!, emptyModels)
    }
    
    func testDevice() throws {
        let device = MacModels.getDevice(by: "MacBookPro13,1")
        XCTAssertEqual(device?.modelName, "MacBook Pro (13-inch, 2016, Two Thunderbolt 3 ports)")
    }
}
