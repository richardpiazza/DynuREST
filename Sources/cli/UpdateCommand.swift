import ArgumentParser
import DynuREST
import SessionPlus

struct UpdateCommand: AsyncParsableCommand {
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "update",
            abstract: "Perform an IP update against the Dynu.com API",
            usage: nil,
            discussion: "",
            version: "1.0",
            shouldDisplay: true,
            subcommands: [],
            defaultSubcommand: nil,
            helpNames: .shortAndLong
        )
    }
    
    @Argument(help: "Credential used to perform actions against the API.")
    var username: String
    
    @Argument(help: "Credential used to perform actions against the API.")
    var password: String
    
    @Option(help: "The group/location of addresses to update. (Takes precedence over other options.)")
    var group: String?
    
    @Option(help: "Alias of 'group'.")
    var location: String?
    
    @Option(help: "Collection of hostnames to update. (Comma separated.)")
    var hostname: String?
    
    @Flag(help: "Prefer IPv6 addresses (Trusted Global Unicast first).")
    var v6: Bool = false
    
    func run() async throws {
        guard !username.isEmpty && !password.isEmpty else {
            throw ValidationError("Credentials must be supplied")
        }
        
        let authorization = Authorization.basic(username: username, password: password)
        
        let addresses = await DynuIPUpdater.shared.requestIP(preferIPv6: v6)
        guard let address = addresses.first else {
            throw ValidationError("Failed to retrieve IP Address")
        }
        
        let responseCode = try await DynuIPUpdater.shared.updateAddress(
            address,
            using: authorization,
            hostname: hostname,
            group: group ?? location
        )
        
        print(responseCode.description)
        print(responseCode.localizedDescription)
    }
}
