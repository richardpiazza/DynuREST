import Foundation
import CodeQuickKit

/// API
/// Provides a wrapper around CodeQuickKit.WebAPI that expands for a username/password credential
/// combination. The `update()` function will execute the query and parse the `ResponseCode` returned.
public class API: HTTPClient {
    public static var shared: API = API()
    public static var insecure: API = API(secure: false)
    
    private static var http = "http://api.dynu.com"
    private static var https = "https://api.dynu.com"
    
    public var baseURL: URL
    public var session: URLSession
    public var authorization: HTTP.Authorization?
    
    private init(secure: Bool = true) {
        var path = type(of: self).http
        if secure {
            path = type(of: self).https
        }
        
        guard let url = URL(string: path) else {
            fatalError("Failed to initialize URL with string: \(path)")
        }
        
        baseURL = url
        session = URLSession(configuration: URLSessionConfiguration.default)
    }
}

public extension HTTPClient {
    ///
    func update(ip: String, hostname: String? = nil, location: String? = nil, completion: @escaping HTTP.DataTaskCompletion) {
        var queryItems = [URLQueryItem]()
        
        if ip.isIPv4 {
            queryItems.append(URLQueryItem(name: "myip", value: ip))
        } else if ip.isIPv6 {
            queryItems.append(URLQueryItem(name: "myipv6", value: ip))
        } else {
            Log.warn("IP Address was not IPv4 nor IPv6")
            completion(ResponseCode.badRequest.rawValue, nil, nil, ResponseCode.badRequest)
            return
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
