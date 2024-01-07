import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import SessionPlus
import ShellOut

/// Uses the `ifconfig` command on the local machine to determine the
/// IPv6 global unicast address
public class IFConfigCommand: IPSource {
    
    public static var shared: IFConfigCommand = .init()
    
    private init() {
    }
    
    public func ipAddress() async throws -> IPAddress {
        let output = try shellOut(to: "ifconfig | grep inet6 | grep -v fe80 | grep secured")
        let components = output.split(separator: " ")
        let addresses = components.compactMap { IPAddress.make(from: String($0)) }
        guard let address = addresses.first else {
            throw DynuRESTError.format(output)
        }
        
        return address
    }
}
