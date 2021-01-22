import Foundation
import SessionPlus
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@available(*, deprecated, renamed: "DynuAPI")
public typealias API = DynuAPI

/// An implementation of the `SessionPlus.HTTPClient` that is configured for the Dynu.com API.
public class DynuAPI: HTTPClient {
    public static let shared: DynuAPI = DynuAPI()
    @available(*, deprecated, message: "Only secure API should be used")
    public static let insecure: DynuAPI = DynuAPI(secure: false)
    
    private static let http: URL = URL(string: "http://api.dynu.com")!
    private static let https: URL = URL(string: "https://api.dynu.com")!
    
    public var baseURL: URL
    public var session: URLSession
    public var authorization: HTTP.Authorization?
    
    private init(secure: Bool = true) {
        baseURL = secure ? Self.https : Self.http
        session = URLSession(configuration: URLSessionConfiguration.default)
    }
}

public extension HTTPClient {
    /// Perform an update against the Dynu IP Updater API.
    ///
    /// - parameter currentAddress:
    /// - parameter username:
    /// - parameter password:
    /// - parameter hostname:
    /// - parameter group:
    /// - parameter completion:
    mutating func update(address: IPAddress, username: String, password: String, hostname: String?, group: String?, completion: @escaping (ResponseCode) -> Void) {
        guard !username.isEmpty && !password.isEmpty else {
            completion(.unauthorized)
            return
        }
        
        authorization = .basic(username: username, password: password)
        
        var queryItems = [URLQueryItem]()
        
        switch address.version {
        case .IPv4:
            queryItems.append(URLQueryItem(name: "myip", value: address.rawValue))
        case .IPv6:
            queryItems.append(URLQueryItem(name: "myipv6", value: address.rawValue))
        }
        
        if let hostname = hostname {
            queryItems.append(URLQueryItem(name: "hostname", value: hostname))
        }
        
        if let group = group {
            queryItems.append(URLQueryItem(name: "location", value: group))
        }
        
        get("nic/update", queryItems: queryItems) { (statusCode, headers, data, error) in
            guard let responseObject = data else {
                completion(.badRequest)
                return
            }
            
            guard let body = String(data: responseObject, encoding: .utf8) else {
                completion(.badRequest)
                return
            }
            
            completion(ResponseCode(stringValue: body))
        }
    }
    
    /// Execute the query and parses the `ResponseCode` returned.
    @available(*, deprecated, renamed: "update(address:username:password:hostname:group:completion:)")
    func update(ip: String, hostname: String? = nil, location: String? = nil, completion: @escaping HTTP.DataTaskCompletion) {
        guard let address = IPAddress(rawValue: ip) else {
            print("IP Address was not IPv4 nor IPv6")
            completion(ResponseCode.badRequest.rawValue, nil, nil, ResponseCode.badRequest)
            return
        }
        
        var queryItems = [URLQueryItem]()
        
        switch address.version {
        case .IPv4:
            queryItems.append(URLQueryItem(name: "myip", value: ip))
        case .IPv6:
            queryItems.append(URLQueryItem(name: "myipv6", value: ip))
        }
        
        if let hostname = hostname {
            queryItems.append(URLQueryItem(name: "hostname", value: hostname))
        }
        
        if let location = location {
            queryItems.append(URLQueryItem(name: "location", value: location))
        }
        
        
        self.get("nic/update", queryItems: queryItems) { (statusCode, headers, data, error) in
            guard let responseObject = data else {
                completion(ResponseCode.badRequest.rawValue, headers, data, ResponseCode.badRequest)
                return
            }
            
            guard let body = String(data: responseObject, encoding: .utf8) else {
                completion(ResponseCode.badRequest.rawValue, headers, responseObject, ResponseCode.badRequest)
                return
            }
            
            let code = ResponseCode(stringValue: body)
            if code == .ok || code == .noContent {
                completion(code.rawValue, headers, data, nil)
            } else {
                completion(code.rawValue, headers, data, code)
            }
        }
    }
}
