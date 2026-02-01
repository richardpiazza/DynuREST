@testable import DynuREST
import SessionPlus
import SessionPlusEmulation
import Testing

struct DynuAPITests {

    private class EmulatedDynuClient: EmulatedClient, DynuClient {}

    private static let addressV4 = IPAddress.ipV4("24.7.206.125")
    private static let addressV6 = IPAddress.ipV6("2601:445:8400:42f:517e:7782:4650:9367")
    private static let hostname = "dynurest.freeddns.org"
    private static let okResponse: Response = AnyResponse(statusCode: .ok, headers: .init(), body: "good".data(using: .utf8)!)

    private static func client() -> DynuClient {
        let v4Request = AnyRequest(path: "nic/update", queryItems: [
            QueryItem(name: "myip", value: addressV4.description),
            QueryItem(name: "hostname", value: hostname),
        ])

        let v6Request = AnyRequest(path: "nic/update", queryItems: [
            QueryItem(name: "myipv6", value: addressV6.description),
            QueryItem(name: "hostname", value: hostname),
        ])

        return EmulatedDynuClient(
            requestResponse: [
                (v4Request, okResponse),
                (v6Request, okResponse),
            ]
        )
    }

    private let username = "bob"
    private let password = "secret"

    @Test func verifyIPv4Update() async throws {
        let client = Self.client()
        let responseCode = try await client.updateAddress(
            Self.addressV4,
            using: .basic(username: username, password: password),
            hostname: Self.hostname
        )
        #expect(responseCode == .ok)
    }

    @Test func verifyIPv6Update() async throws {
        let client = Self.client()
        let responseCode = try await client.updateAddress(
            Self.addressV6,
            using: .basic(username: username, password: password),
            hostname: Self.hostname
        )
        #expect(responseCode == .ok)
    }
}
