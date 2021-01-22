import XCTest
import SessionPlus
@testable import DynuREST
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class DynuAPITests: XCTestCase {

    static var allTests = [
        ("testIPv4Update", testIPv4Update),
        ("testIPv6Update", testIPv6Update),
    ]
    
    private struct API: HTTPClient, HTTPInjectable {
        var baseURL: URL = URL(string: "https://api.dynu.com/")!
        var session: URLSession = URLSession(configuration: .default)
        var authorization: HTTP.Authorization?
        var injectedResponses: [InjectedPath : InjectedResponse] = [:]
    }
    
    private let addressV4 = IPAddress(rawValue: "24.7.206.125")!
    private let addressV6 = IPAddress(rawValue: "2601:445:8400:42f:517e:7782:4650:9367")!
    private let username = "bob"
    private let password = "secret"
    private let hostname = "dynurest.freeddns.org"
    private var api = API()
    
    private var ipV4Path: InjectedPath {
        return InjectedPath(string: "https://api.dynu.com/nic/update?myip=\(addressV4)&hostname=\(hostname)")
    }
    
    private var okResponse: InjectedResponse {
        var response = InjectedResponse()
        response.statusCode = 200
        response.data = "good".data(using: .utf8)
        return response
    }
    
    private var ipV6Path: InjectedPath {
        return InjectedPath(string: "https://api.dynu.com/nic/update?myipv6=\(addressV6)&hostname=\(hostname)")
    }
    
    override func setUp() {
        super.setUp()
        
        api.injectedResponses[ipV4Path] = okResponse
        api.injectedResponses[ipV6Path] = okResponse
    }
    
    override func tearDown() {
        api.injectedResponses[ipV4Path] = nil
        api.injectedResponses[ipV6Path] = nil
        
        super.tearDown()
    }
    
    func testIPv4Update() {
        let exp = self.expectation(description: "ipv4")
        
        api.update(address: addressV4, username: username, password: password, hostname: hostname, group: nil) { (responseCode) in
            guard responseCode == .ok else {
                XCTFail("Invalid Response Code: \(responseCode)")
                return
            }
            
            exp.fulfill()
        }
        
        self.waitForExpectations(timeout: 2.0) { (error) in
            if let e = error {
                print(e)
                XCTFail()
            }
        }
    }
    
    func testIPv6Update() {
        let exp = self.expectation(description: "ipv6")
        
        api.update(address: addressV6, username: username, password: password, hostname: hostname, group: nil) { (responseCode) in
            guard responseCode == .ok else {
                XCTFail("Invalid Response Code: \(responseCode)")
                return
            }
            
            exp.fulfill()
        }
        
        self.waitForExpectations(timeout: 2.0) { (error) in
            if let e = error {
                print(e)
                XCTFail()
            }
        }
    }
}
