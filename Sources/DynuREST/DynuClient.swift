import Foundation
import SessionPlus

public protocol DynuClient: Client {
    func updateAddress(_ address: IPAddress, using authorization: Authorization, hostname: String?, group: String?) async throws -> ResponseCode
}

public extension DynuClient {
    /// Perform an update against the Dynu IP Updater API.
    ///
    /// - parameters:
    ///   - address: The `IPAddress` that should be used as a new DNS value.
    ///   - authorization: Credentials used to authenticate against the Dynu API
    ///   - hostname: One or more comma-separated hostnames whose IP address requires update.
    ///   - group: Use 'location' parameter if you want to update IP address for a collection of hostnames. (`hostname` will be ignored)
    func updateAddress(_ address: IPAddress, using authorization: Authorization, hostname: String? = nil, group: String? = nil) async throws -> ResponseCode {
        var queryItems: [URLQueryItem] = []
        
        switch address.version {
        case .IPv4:
            queryItems.append(URLQueryItem(name: "myip", value: address.rawValue))
        case .IPv6:
            queryItems.append(URLQueryItem(name: "myipv6", value: address.rawValue))
        }
        
        if let hostname = hostname, !hostname.isEmpty {
            queryItems.append(URLQueryItem(name: "hostname", value: hostname))
        }
        
        if let group = group, !group.isEmpty {
            queryItems.append(URLQueryItem(name: "location", value: group))
        }
        
        let request = AnyRequest(path: "nic/update", queryItems: queryItems)
        let authorizedRequest = request.authorized(authorization)
        let response: String = try await performRequest(authorizedRequest)
        return ResponseCode(stringValue: response)
    }
}
