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
        case ipifyApi
        case ifconfigApi
        case ifconfigCommand
        
        @available(*, deprecated, renamed: "ipifyApi")
        static var ipify: Self { ipifyApi }
        
        @available(*, deprecated, renamed: "ifconfigApi")
        static var ifconfig: Self { ifconfigApi }
    }
    
    @Argument(help: "Lookup Source ['ipify', 'ifconfigApi', 'ifconfigCommand']")
    var source: Source
    
    func run() async throws {
        switch source {
        case .ipifyApi:
            let address = try await IPIfyClient.shared.ipAddress()
            print(address.description)
        case .ifconfigApi:
            let address = try await IFConfigClient.shared.ipAddress()
            print(address.description)
        case .ifconfigCommand:
            let address = try await IFConfigCommand.shared.ipAddress()
            print(address.description)
        }
    }
}
