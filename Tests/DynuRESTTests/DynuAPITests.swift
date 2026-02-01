@testable import DynuREST
import SessionPlus
import SessionPlusEmulation
import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class DynuAPITests: XCTestCase {

    private let addressV4 = IPAddress.ipV4("24.7.206.125")
    private let addressV6 = IPAddress.ipV6("2601:445:8400:42f:517e:7782:4650:9367")
    private let username = "bob"
    private let password = "secret"
    private let hostname = "dynurest.freeddns.org"
    private var client: DynuClient!

    private var okResponse: Response {
        AnyResponse(statusCode: .ok, headers: .init(), body: "good".data(using: .utf8)!)
    }

    private class EmulatedDynuClient: EmulatedClient, DynuClient {}

    override func setUp() {
        super.setUp()

        let v4Request = AnyRequest(path: "nic/update", queryItems: [
            QueryItem(name: "myip", value: addressV4.description),
            QueryItem(name: "hostname", value: hostname),
        ])

        let v6Request = AnyRequest(path: "nic/update", queryItems: [
            QueryItem(name: "myipv6", value: addressV6.description),
            QueryItem(name: "hostname", value: hostname),
        ])

        client = EmulatedDynuClient(requestResponse: [
            (v4Request, okResponse),
            (v6Request, okResponse),
        ])
    }

    func testIPv4Update() async throws {
        let responseCode = try await client.updateAddress(addressV4, using: .basic(username: username, password: password), hostname: hostname)
        XCTAssertEqual(responseCode, .ok)
    }

    func testIPv6Update() async throws {
        let responseCode = try await client.updateAddress(addressV6, using: .basic(username: username, password: password), hostname: hostname)
        XCTAssertEqual(responseCode, .ok)
    }
}
