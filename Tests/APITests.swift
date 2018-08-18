import XCTest
import CodeQuickKit
@testable import DynuREST

class APITests: XCTestCase {

    let ipv4 = "24.7.206.125"
    let hostname = "dynurest.freeddns.org"
    
    var ipv4OKPath: InjectedPath {
        return InjectedPath(string: "http://api.dynu.com/nic/update?myip=\(ipv4)&hostname=\(hostname)")
    }
    
    var ipv4OKResponse: InjectedResponse {
        var response = InjectedResponse()
        response.statusCode = 200
        response.data = "good".data(using: .utf8)
        return response
    }
    
    override func setUp() {
        super.setUp()
        
        API.insecure.injectedResponses[ipv4OKPath] = ipv4OKResponse
    }
    
    override func tearDown() {
        API.insecure.injectedResponses[ipv4OKPath] = nil
        
        super.tearDown()
    }
    
    func testIPv4OK() {
        let exp = self.expectation(description: "ipv4")
        
        API.insecure.update(ip: ipv4, hostname: hostname, location: nil) { (statusCode, headers, data, error) in
            guard statusCode == 200 else {
                XCTFail()
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
