import Foundation
import SessionPlus
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A Simple Public IP Address API
///
/// Used for IPv4 Lookup
public class IPIfyClient: URLSessionClient, IPProvider {
    
    private struct IPResponse: Decodable {
        let ip: String
    }
    
    public static var shared: IPIfyClient = .init()
    
    private init() {
        super.init(baseURL: .ipify)
    }
    
    public func ipAddress() async throws -> IPAddress {
        let request = AnyRequest(queryItems: [URLQueryItem(name: "format", value: "json")])
        let response: IPResponse = try await performRequest(request)
        guard let address = IPAddress(rawValue: response.ip) else {
            throw DynuRESTError.format(response.ip)
        }
        return address
    }
}
