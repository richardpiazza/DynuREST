import ArgumentParser

#if swift(>=5.6)
@main struct MainCommand: AsyncParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "dynu",
            abstract: "CLI to the DynuREST swift package.",
            usage: nil,
            discussion: "",
            version: "1.0",
            shouldDisplay: true,
            subcommands: [IPCommand.self, UpdateCommand.self],
            defaultSubcommand: nil,
            helpNames: .shortAndLong
        )
    }
}
#else
struct MainCommand: AsyncParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "dynu",
            abstract: "CLI to the DynuREST swift package.",
            usage: nil,
            discussion: "",
            version: "1.0",
            shouldDisplay: true,
            subcommands: [IPCommand.self, UpdateCommand.self],
            defaultSubcommand: nil,
            helpNames: .shortAndLong
        )
    }
}

@main enum Main: AsyncMainProtocol {
    typealias Command = MainCommand
}
#endif
