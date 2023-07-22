import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
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
        
        switch address {
        case .ipV4(let value):
            queryItems.append(URLQueryItem(name: "myip", value: value))
        case .ipV6(let value):
            queryItems.append(URLQueryItem(name: "myipv6", value: value))
        }
        
        switch (group, hostname) {
        case (.some(let location), _):
            queryItems.append(URLQueryItem(name: "location", value: location))
        case (.none, .some(let hosts)):
            queryItems.append(URLQueryItem(name: "hostname", value: hosts))
        case (.none, .none):
            switch authorization {
            case .basic(let username, _):
                queryItems.append(URLQueryItem(name: "username", value: username))
            default:
                break
            }
        }
        
        let request = AnyRequest(path: "nic/update", queryItems: queryItems)
        let authorizedRequest = request.authorized(authorization)
        
        let url = (try? URLRequest(request: authorizedRequest).url?.absoluteString) ?? ""
        print(url)
        
        let response = try await performRequest(authorizedRequest)
        let value = String(data: response.data, encoding: .utf8) ?? ""
        return ResponseCode(stringValue: value)
    }
}
