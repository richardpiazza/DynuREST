import Foundation

/// An extension of Swift.String with regex pattern matching of IPv4 and IPv6 address.
extension String {
    /// Tests if the string is an IPv4 address.
    @available(*, deprecated, message: "Use IPAddress")
    var isIPv4: Bool { IPAddress.Version.IPv4.matches(self) }
    
    /// Tests if the string is an IPv6 address.
    @available(*, deprecated, message: "Use IPAddress")
    var isIPv6: Bool { IPAddress.Version.IPv6.matches(self) }
}
