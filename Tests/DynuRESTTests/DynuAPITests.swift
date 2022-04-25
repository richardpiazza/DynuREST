import XCTest
import SessionPlus
import SessionPlusEmulation
@testable import DynuREST
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class DynuAPITests: XCTestCase {
    
    private let addressV4 = IPAddress(rawValue: "24.7.206.125")!
    private let addressV6 = IPAddress(rawValue: "2601:445:8400:42f:517e:7782:4650:9367")!
    private let username = "bob"
    private let password = "secret"
    private let hostname = "dynurest.freeddns.org"
    private var client: DynuClient!
    
    private var okResponse: Response {
        AnyResponse(statusCode: .ok, headers: .init(), data: "good".data(using: .utf8)!)
    }
    
    private class EmulatedDynuClient: EmulatedClient, DynuClient {
    }
    
    override func setUp() {
        super.setUp()
        
        client = EmulatedDynuClient(responseCache: [
            "https://api.dynu.com/nic/update?myip=\(addressV4)&hostname=\(hostname)": .success(okResponse),
            "https://api.dynu.com/nic/update?myipv6=\(addressV6)&hostname=\(hostname)": .success(okResponse)
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
