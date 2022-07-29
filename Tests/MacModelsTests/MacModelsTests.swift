import XCTest
@testable import MacModels

final class MacModelsTests: XCTestCase {
    func testAllLocalDevices() throws {
        let devices = try MacModels.getAllDevicesLocally().first(where: { $0.name == "Mac mini"})?.devices
        XCTAssertNotNil(devices)
        let emptyModels: [Device] = []
        XCTAssertNotEqual(devices!, emptyModels)
    }
    
    func testAllRemoteDevices() async throws {
        let devices = try await MacModels.getAllDevicesOnline().first(where: { $0.name == "Mac mini"})?.devices
        XCTAssertNotNil(devices)
        let emptyModels: [Device] = []
        XCTAssertNotEqual(devices ?? [], emptyModels)
    }
    
    func testDevice() async throws {
        let device = await MacModels.getDevice(by: "MacBookPro13,1")
        XCTAssertEqual(device?.name, "MacBook Pro (13-inch, 2016, Two Thunderbolt 3 ports)")
    }
    }
}
