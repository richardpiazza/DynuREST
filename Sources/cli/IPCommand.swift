import ArgumentParser
import DynuREST

struct IPCommand: AsyncParsableCommand {
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "ip",
            abstract: "Query sources for IP information",
            usage: nil,
            discussion: "",
            version: "1.0",
            shouldDisplay: true,
            subcommands: [],
            defaultSubcommand: nil,
            helpNames: .shortAndLong
        )
    }
    
    enum Source: String, ExpressibleByArgument {
        case ipify
        case ifconfig
    }
    
    @Argument(help: "Lookup Source ['ipify', 'ifconfig']")
    var source: Source
    
    func run() async throws {
        switch source {
        case .ipify:
            let address = try await IPIfyClient.shared.ipAddress()
            print(address.description)
        case .ifconfig:
            let address = try await IFConfigClient.shared.ipAddress()
            print(address.description)
        }
    }
}
