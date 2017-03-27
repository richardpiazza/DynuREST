import Foundation
import CodeQuickKit

/// API
/// Provides a wrapper around CodeQuickKit.WebAPI that expands for a username/password credential
/// combination. The `update()` function will execute the query and parse the `ResponseCode` returned.
public class API: WebAPI {
    public var username: String = ""
    public var password: String = ""
    
    public convenience init(username: String, password: String) {
        self.init(baseURL: URL(string: "https://api.dynu.com"), sessionDelegate: nil)
        self.username = username
        self.password = password
    }
    
    override public func request(forPath path: String, queryItems: [URLQueryItem]?, method: WebAPIRequestMethod, data: Data?) -> NSMutableURLRequest? {
        guard let request = super.request(forPath: path, queryItems: queryItems, method: method, data: data) else {
            return nil
        }
        
        let userpass = "\(username):\(password)"
        
        guard let data = userpass.data(using: String.Encoding.utf8, allowLossyConversion: true) else {
            return nil
        }
        
        let base64 = data.base64EncodedString(options: [])
        let auth = "Basic \(base64)"
        
        request.setValue(auth, forHTTPHeaderField: WebAPIHeaderKey.Authorization)
        
        return request
    }
    
    public func update(ip: String, hostname: String? = nil, location: String? = nil, completion: @escaping WebAPICompletion) {
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
        
        execute(path: "nic/update", queryItems: queryItems, method: .Get, data: nil) { (statusCode, response, responseObject, error) in
            guard let data = responseObject as? Data else {
                completion(ResponseCode.badRequest.rawValue, response, responseObject, ResponseCode.badRequest.error)
                return
            }
            
            guard let body = String(data: data, encoding: .utf8) else {
                completion(ResponseCode.badRequest.rawValue, response, responseObject, ResponseCode.badRequest.error)
                return
            }
            
            let code = ResponseCode(stringValue: body)
            
            completion(code.rawValue, response, responseObject, code.error)
        }
    }
}
