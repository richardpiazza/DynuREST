import Foundation
import SessionPlus
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// IFConfig.co: "The best tool to find your own IP address, and information about it."
///
/// Used for IPv6 Lookup
public class IFConfigClient: BaseURLSessionClient, IPSource {
    
    /// Response received from the IP api
    ///
    /// ```json
    /// {
    ///   "ip": "73.24.13.58",
    ///   "ip_decimal": 1226313018,
    ///   "country": "United States",
    ///   "country_iso": "US",
    ///   "country_eu": false,
    ///   "region_name": "Minnesota",
    ///   "region_code": "MN",
    ///   "metro_code": 613,
    ///   "zip_code": "55422",
    ///   "city": "Minneapolis",
    ///   "latitude": 45.0123,
    ///   "longitude": -93.3447,
    ///   "time_zone": "America/Chicago",
    ///   "asn": "AS7922",
    ///   "asn_org": "COMCAST-7922",
    ///   "hostname": "c-73-24-13-58.hsd1.mn.comcast.net",
    ///   "user_agent": {
    ///     "product": "Paw",
    ///     "version": "3.3.6",
    ///     "comment": "(Macintosh; OS X/12.3.1) GCDHTTPRequest",
    ///     "raw_value": "Paw/3.3.6 (Macintosh; OS X/12.3.1) GCDHTTPRequest"
    ///   }
    /// }
    /// ```
    private struct IPResponse: Decodable {
        let ip: IPAddress
    }
    
    public static var shared: IFConfigClient = .init()
    
    private init() {
        super.init(baseURL: .ifconfig)
    }
    
    public func ipAddress() async throws -> IPAddress {
        let request = AnyRequest(path: "json")
        let response: IPResponse = try await performRequest(request)
        return response.ip
    }
}
