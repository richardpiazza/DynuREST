@testable import DynuREST
import Foundation
import Testing

struct IPAddressTests {

    private struct Node: Codable {
        var address: IPAddress
    }

    @Test func validIPv4() throws {
        let address = try #require(IPAddress.make(from: "24.7.206.125"))
        #expect(address.isIPv4)
    }

    @Test func invalidIPv4() {
        let invalidAddress = IPAddress.make(from: "24.256.33.111")
        #expect(invalidAddress == nil)
    }

    @Test func validIPv6() throws {
        let address = try #require(IPAddress.make(from: "fdfe:1357:2dc9:2:c95:6e09:21b7:5110"))
        #expect(address.isIPv6)
    }

    @Test func invalidIPv6() {
        let invalidAddress = IPAddress.make(from: "2601.445:8001:d039:39d8.8bdc:a99:40a5")
        #expect(invalidAddress == nil)
    }

    @Test func encode() throws {
        let address = IPAddress.ipV4("73.24.13.58")
        let data = try JSONEncoder().encode(address)
        let json = try #require(String(data: data, encoding: .utf8))
        #expect(json == "\"73.24.13.58\"")
    }

    @Test func decode() throws {
        let json = "\"2601:445:8400:42f:517e:7782:4650:9367\""
        let data = try #require(json.data(using: .utf8))
        let address = try JSONDecoder().decode(IPAddress.self, from: data)
        #expect(address.isIPv6)
    }
}
