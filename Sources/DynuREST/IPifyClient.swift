import Foundation
import SessionPlus
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A Simple Public IP Address API
///
/// Used for IPv4 Lookup
public class IPIfyClient: BaseURLSessionClient, IPSource {

    private struct IPResponse: Decodable {
        let ip: IPAddress
    }

    public static var shared: IPIfyClient = .init()

    private init() {
        super.init(baseURL: .ipify)
    }

    public func ipAddress() async throws -> IPAddress {
        let request = AnyRequest(queryItems: [URLQueryItem(name: "format", value: "json")])
        let response: IPResponse = try await performRequest(request)
        return response.ip
    }
}
