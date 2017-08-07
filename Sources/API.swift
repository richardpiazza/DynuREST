import Foundation
import CodeQuickKit

/// API
/// Provides a wrapper around CodeQuickKit.WebAPI that expands for a username/password credential
/// combination. The `update()` function will execute the query and parse the `ResponseCode` returned.
public class API: WebAPI {
    public static var shared: API = API()
    public static var insecure: API = API(secure: false)
    
    private static var http = "http://api.dynu.com"
    private static var https = "https://api.dynu.com"
    
    public var username: String = ""
    public var password: String = ""
    
    public enum Errors: Error {
        case invalidAuthentication
    }
    
    public convenience init(secure: Bool = true) {
        var url = type(of: self).http
        if secure {
            url = type(of: self).https
        }
        self.init(baseURL: URL(string: url), sessionDelegate: nil)
    }
    
    public convenience init(username: String, password: String, secure: Bool = true) {
        var url = type(of: self).http
        if secure {
            url = type(of: self).https
        }
        self.init(baseURL: URL(string: url), sessionDelegate: nil)
        self.username = username
        self.password = password
    }
    
    public override func request(method: WebAPI.HTTPRequestMethod, path: String, queryItems: [URLQueryItem]?, data: Data?) throws -> NSMutableURLRequest {
        let request = try super.request(method: method, path: path, queryItems: queryItems, data: data)
        
        let userpass = "\(username):\(password)"
        
        guard let data = userpass.data(using: String.Encoding.utf8, allowLossyConversion: true) else {
            throw Errors.invalidAuthentication
        }
        
        let base64 = data.base64EncodedString(options: [])
        let auth = "Basic \(base64)"
        
        request.setValue(auth, forHTTPHeaderField: WebAPI.HTTPHeaderKey.Authorization)
        
        return request
    }
    
    public func update(ip: String, hostname: String? = nil, location: String? = nil, completion: @escaping WebAPIRequestCompletion) {
        var queryItems = [URLQueryItem]()
        
        if ip.isIPv4 {
            queryItems.append(URLQueryItem(name: "myip", value: ip))
        } else if ip.isIPv6 {
            queryItems.append(URLQueryItem(name: "myipv6", value: ip))
        } else {
            Log.warn("IP Address was not IPv4 nor IPv6")
            completion(ResponseCode.badRequest.rawValue, nil, nil, ResponseCode.badRequest.error)
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
                completion(ResponseCode.badRequest.rawValue, headers, data, ResponseCode.badRequest.error)
                return
            }
            
            guard let body = String(data: responseObject, encoding: .utf8) else {
                completion(ResponseCode.badRequest.rawValue, headers, responseObject, ResponseCode.badRequest.error)
                return
            }
            
            let code = ResponseCode(stringValue: body)
            
            completion(code.rawValue, headers, data, code.error)
        }
    }
}
