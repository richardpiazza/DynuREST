import Foundation
import SessionPlus
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public final class DynuIPUpdater: BaseURLSessionClient, DynuClient {

    public static var shared: DynuIPUpdater = .init()

    /// Default sources for `IPAddress` lookup.
    ///
    /// This order prefers IPv4 before IPv6
    public static var sources: [IPSource] {
        var ipSources: [IPSource] = [
            IPIfyClient.shared,
            IFConfigClient.shared,
        ]
        #if os(macOS)
        ipSources.append(IFConfigCommand.shared)
        #endif
        return ipSources
    }

    private init() {
        super.init(baseURL: .dynuAPI)
    }

    /// Retrieves address information from all the provided sources.
    @available(*, deprecated, renamed: "requestIP(from:)")
    public func requestIP(_ sources: [IPSource] = DynuIPUpdater.sources) async -> [IPAddress] {
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

    /// Retrieves a collection of `IPAddress` using the _default_ sources.
    ///
    /// - parameters:
    ///   - preferIPv6: When true, the source collection will order IPv6 providers first.
    /// - returns: Collection of available `IPAddress` as provided by the default sources.
    public func requestIP(preferIPv6: Bool) async -> [IPAddress] {
        if preferIPv6 {
            return await requestIP(from: DynuIPUpdater.sources.reversed())
        } else {
            return await requestIP(from: DynuIPUpdater.sources)
        }
    }

    /// Retrieves a collection of `IPAddress`.
    ///
    /// - parameters:
    ///   - sources: The collection of `IPSource` which should be queried for addresses.
    /// - returns: Collection of available `IPAddress` as provided by the `sources`.
    public func requestIP(from sources: [IPSource]) async -> [IPAddress] {
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
