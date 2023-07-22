import Foundation
import SessionPlus
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public final class DynuIPUpdater: BaseURLSessionClient, DynuClient {
    
    public static var shared: DynuIPUpdater = .init()
    
    private init() {
        super.init(baseURL: .dynuAPI)
    }
    
    /// Retrieves address information from all the provided sources.
    public func requestIP(_ sources: [IPSource] = [IPIfyClient.shared, IFConfigClient.shared]) async -> [IPAddress] {
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
