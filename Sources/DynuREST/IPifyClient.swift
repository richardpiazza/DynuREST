import Foundation
import SessionPlus
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A Simple Public IP Address API
///
/// Used for IPv4 Lookup
public final class IPIfyClient: IPSource {

    private struct IPResponse: Decodable {
        let ip: IPAddress
    }

    private let client: any Client

    public init() {
        client = BaseURLSessionClient(baseURL: .ipify)
    }

    @concurrent public func ipAddress() async throws -> IPAddress {
        let request = AnyRequest(
            path: "",
            queryItems: [QueryItem(name: "format", value: "json")],
        )
        let response: IPResponse = try await client.performRequest(request)
        return response.ip
    }
}
