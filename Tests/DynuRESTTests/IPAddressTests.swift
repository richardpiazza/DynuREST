@testable import DynuREST
import XCTest

final class IPAddressTests: XCTestCase {

    private struct Node: Codable {
        var address: IPAddress
    }

    func testValidIPv4() throws {
        let address = try XCTUnwrap(IPAddress.make(from: "24.7.206.125"))
        if case .ipV6 = address {
            XCTFail("Expected IPv4 Address")
        }
    }

    func testInvalidIPv4() {
        let invalidAddress = IPAddress.make(from: "24.256.33.111")
        XCTAssertNil(invalidAddress)
    }

    func testValidIPv6() throws {
        let address = try XCTUnwrap(IPAddress.make(from: "fdfe:1357:2dc9:2:c95:6e09:21b7:5110"))
        if case .ipV4 = address {
            XCTFail("Expected IPv6 Address")
        }
    }

    func testInvalidIPv6() {
        let invalidAddress = IPAddress.make(from: "2601.445:8001:d039:39d8.8bdc:a99:40a5")
        XCTAssertNil(invalidAddress)
    }

    func testEncode() throws {
        let address = IPAddress.ipV4("73.24.13.58")
        let data = try JSONEncoder().encode(address)
        let json = try XCTUnwrap(String(data: data, encoding: .utf8))
        XCTAssertEqual(json, "\"73.24.13.58\"")
    }

    func testDecode() throws {
        let json = "\"2601:445:8400:42f:517e:7782:4650:9367\""
        let data = try XCTUnwrap(json.data(using: .utf8))
        let address = try JSONDecoder().decode(IPAddress.self, from: data)
        if case .ipV4 = address {
            XCTFail("Expected IPv6 Address")
        }
    }
}
