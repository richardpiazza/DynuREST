import XCTest
@testable import DynuREST

final class IPAddressTests: XCTestCase {
    
    static var allTests = [
        ("testIPv4", testIPv4),
        ("testIPv6", testIPv6),
        ("testEncode", testEncode),
        ("testDecode", testDecode),
    ]
    
    private struct Node: Codable {
        var address: IPAddress
    }
    
    func testIPv4() throws {
        let address = try XCTUnwrap(IPAddress(rawValue: "24.7.206.125"))
        XCTAssertTrue(address.isIPv4)
        XCTAssertFalse(address.isIPv6)
        
        let invalidAddress = IPAddress(rawValue: "24.256.33.111")
        XCTAssertNil(invalidAddress)
    }
    
    func testIPv6() throws {
        let address = try XCTUnwrap(IPAddress(rawValue: "fdfe:1357:2dc9:2:c95:6e09:21b7:5110"))
        XCTAssertTrue(address.isIPv6)
        XCTAssertFalse(address.isIPv4)
        
        let invalidAddress = IPAddress(rawValue: "2601.445:8001:d039:39d8.8bdc:a99:40a5")
        XCTAssertNil(invalidAddress)
    }
    
    func testEncode() throws {
        let address = try XCTUnwrap(IPAddress(rawValue: "73.24.13.58"))
        let node = Node(address: address)
        let data = try JSONEncoder().encode(node)
        let json = try XCTUnwrap(String(data: data, encoding: .utf8))
        XCTAssertEqual(json, "{\"address\":\"73.24.13.58\"}")
    }
    
    func testDecode() throws {
        let json = "{\"address\":\"2601:445:8400:42f:517e:7782:4650:9367\"}"
        let data = try XCTUnwrap(json.data(using: .utf8))
        let node = try JSONDecoder().decode(Node.self, from: data)
        XCTAssertTrue(node.address.isIPv6)
    }
}
