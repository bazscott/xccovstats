import Foundation

public struct ShellCommands {

	public typealias ShellResult = (exitCode: Int, output: String)

    public func run(_ command: String) -> ShellResult {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", command]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String

		task.waitUntilExit()
    	let status = Int(task.terminationStatus)

        return ShellResult(status, output)
    }

    public func runXcodebuild(workspace: String, scheme: String, sim: String) {
        let result = run("xcodebuild -workspace \(workspace) -scheme \(scheme) -derivedDataPath Build -destination \(sim) -enableCodeCoverage YES clean build test")
		if result.exitCode != EXIT_SUCCESS { exit(EXIT_FAILURE) }
    }

}
