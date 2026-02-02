import ArgumentParser

@main struct MainCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "dynu",
        abstract: "CLI to the DynuREST swift package.",
        version: "1.0",
        subcommands: [IPCommand.self, UpdateCommand.self],
        helpNames: .shortAndLong
    )
}
