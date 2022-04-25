import Foundation

public struct IPAddress: RawRepresentable, Codable {
    
    public enum Version: String, CaseIterable {
        case IPv4 = "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
        case IPv6 = "(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))"
        
        public init?(_ value: String) {
            guard let version = Version.allCases.first(where: { $0.matches(value) }) else {
                return nil
            }
            
            self = version
        }
        
        public func matches(_ value: String) -> Bool {
            do {
                let expression = try NSRegularExpression(pattern: rawValue, options: [])
                let match = expression.matches(in: value, options: [], range: NSRange(location: 0, length: value.count))
                return match.count > 0
            } catch {
                print(error)
                return false
            }
        }
    }
    
    public let rawValue: String
    public let version: Version
    public var isIPv4: Bool { version == .IPv4 }
    public var isIPv6: Bool { version == .IPv6 }
    
    public init?(rawValue: String) {
        guard let version = Version(rawValue) else {
            return nil
        }
        
        self.rawValue = rawValue
        self.version = version
    }
}

extension IPAddress: CustomStringConvertible {
    public var description: String {
        return rawValue
    }
}

public extension IPAddress {
    /// Retrieves address information from all the provided sources.
    static func requestFromSources(_ sources: [IPProvider]) async -> [IPAddress] {
        var addresses: [IPAddress] = []
        for source in sources {
            do {
                let address = try await source.ipAddress()
                addresses.append(address)
            } catch {
                print(error)
            }
        }
        return addresses
    }
}

@available(*, deprecated)
public extension IPAddress {
    /// Retrieves an IPv4 address from IPify.org
    static func getIPv4(_ completion: @escaping IPResult) {
        IPSource.ipify.ipAddress(completion)
    }
    
    /// Retrieves an IPv6 address from IFConfig.co
    static func getIPv6(_ completion: @escaping IPResult) {
        IPSource.ifconfig.ipAddress(completion)
    }
    
    /// Retrieves the first available IP address (v4 first).
    static func getIP(_ completion: @escaping (Result<IPAddress, DynuRESTError>) -> Void) {
        IPSource.ipify.ipAddress { (ipv4) in
            switch ipv4 {
            case .success(let address):
                completion(.success(address))
            case .failure:
                IPSource.ifconfig.ipAddress { (ipv6) in
                    switch ipv6 {
                    case .success(let address):
                        completion(.success(address))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
