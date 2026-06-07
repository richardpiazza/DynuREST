import Foundation
import SessionPlus
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public final class DynuIPUpdater: DynuClient {

    @available(*, deprecated)
    public static var shared: DynuIPUpdater = .init()

    /// Default sources for `IPAddress` lookup.
    ///
    /// This order prefers IPv4 before IPv6
    public static var sources: [any IPSource] {
        var ipSources: [any IPSource] = [
            IPIfyClient(),
            IFConfigClient(),
        ]
        #if os(macOS)
        ipSources.append(IFConfigCommand.shared)
        #endif
        return ipSources
    }

    public let client: any Client

    public init() {
        client = BaseURLSessionClient(baseURL: .dynuAPI)
    }

    /// Retrieves address information from all the provided sources.
    @available(*, deprecated, renamed: "requestIP(from:)")
    public func requestIP(_ sources: [any IPSource] = DynuIPUpdater.sources) async -> [IPAddress] {
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
            await requestIP(from: DynuIPUpdater.sources.reversed())
        } else {
            await requestIP(from: DynuIPUpdater.sources)
        }
    }

    /// Retrieves a collection of `IPAddress`.
    ///
    /// - parameters:
    ///   - sources: The collection of `IPSource` which should be queried for addresses.
    /// - returns: Collection of available `IPAddress` as provided by the `sources`.
    public func requestIP(from sources: [any IPSource]) async -> [IPAddress] {
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
