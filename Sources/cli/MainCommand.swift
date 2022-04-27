import ArgumentParser

@main struct MainCommand: AsyncParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "dynu",
            abstract: "CLI to the DynuREST swift package.",
            usage: nil,
            discussion: "",
            version: "1.0",
            shouldDisplay: true,
            subcommands: [IPCommand.self],
            defaultSubcommand: nil,
            helpNames: .shortAndLong
        )
    }
}
