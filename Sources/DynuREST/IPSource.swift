import Foundation

public protocol IPSource {
    func ipAddress() async throws -> IPAddress
}
