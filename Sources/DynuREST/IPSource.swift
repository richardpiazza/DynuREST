import Foundation
import SessionPlus
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public typealias IPResult = (Result<IPAddress, IPSource.Error>) -> Void

public enum IPSource: String {
    public enum Error: Swift.Error {
        case requestError(Swift.Error)
        case statusCode(Int)
        case response
        case format(String)
    }
    
    /// A Simple Public IP Address API
    ///
    /// Used for IPv4 Loopkup
    case ipify = "IPify.org"
    /// "The best tool to find your own IP address, and information about it."
    ///
    /// Used for IPv6 Lookup
    case ifconfig = "IFConfig.co"
    
    public var baseURL: URL {
        switch self {
        case .ipify: return URL(string: "https://api.ipify.org")!
        case .ifconfig: return URL(string: "https://ifconfig.co")!
        }
    }
    
    private static let _session: URLSession =  URLSession(configuration: .default)
    public var session: URLSession {
        get { Self._session }
        set {}
    }
    
    private static var _authorization: HTTP.Authorization? = nil
    public var authorization: HTTP.Authorization? {
        get { Self._authorization }
        set { Self._authorization = newValue }
    }
    
    private var path: String {
        switch self {
        case .ipify: return ""
        case .ifconfig: return "json"
        }
    }
    
    private var queryItems: [URLQueryItem]? {
        switch self {
        case .ipify: return [URLQueryItem(name: "format", value: "json")]
        case .ifconfig: return nil
        }
    }
}

extension IPSource: HTTPClient {
    public func ipAddress(_ completion: @escaping IPResult) {
        get(path, queryItems: queryItems) { (statusCode, headers, data, error) in
            guard error == nil else {
                completion(.failure(.requestError(error!)))
                return
            }
            
            guard statusCode == 200 else {
                completion(.failure(.statusCode(200)))
                return
            }
            
            guard let responseData = data else {
                completion(.failure(.response))
                return
            }
            
            guard let dictionary = try? JSONSerialization.jsonObject(with: responseData, options: .init()) as? [String: Any] else {
                completion(.failure(.response))
                return
            }
            
            guard let ip = dictionary["ip"] as? String else {
                completion(.failure(.response))
                return
            }
            
            guard let ipAddress = IPAddress(rawValue: ip) else {
                completion(.failure(.format(ip)))
                return
            }
            
            completion(.success(ipAddress))
        }
    }
}
