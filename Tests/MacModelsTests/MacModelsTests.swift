import XCTest
@testable import MacModels

final class MacModelsTests: XCTestCase {
    func testAllLocalDevices() throws {
        let devices = try MacModels.getAllDevices(locally: true).first(where: { $0.name == "Mac mini"})?.devices
        XCTAssertNotNil(devices)
        let emptyModels: [Device] = []
        XCTAssertNotEqual(devices!, emptyModels)
    }
    
    func testAllRemoteDevices() throws {
        let devices = try MacModels.getAllDevices().first(where: { $0.name == "Mac mini"})?.devices
        XCTAssertNotNil(devices)
        let emptyModels: [Device] = []
        XCTAssertNotEqual(devices ?? [], emptyModels)
    }
    
    func testDevice() throws {
        let device = MacModels.getDevice(by: "MacBookPro13,1")
        XCTAssertEqual(device?.modelName, "MacBook Pro (13-inch, 2016, Two Thunderbolt 3 ports)")
    }
}
