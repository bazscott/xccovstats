import Foundation
import Basic
import Utility

public class App {

	// MARK: - Constants

	public let version = "0.1.0"

	let arguments: [String]
	let parser: ArgumentParser
	let versionOption: OptionArgument<Bool>
	let workspaceOption: OptionArgument<String>
	let schemeOption: OptionArgument<String>

	let sim = "'platform=iOS Simulator,OS=11.4,name=iPhone SE'"

	// MARK: - Variables

	var projectData: Project?

	// MARK: - Lifecycle

	public convenience init(arguments: [String]) {
		let parser = ArgumentParser(usage: "[--workspace][--scheme]  [--version]  [--help]", overview: "A utility to help make sense of XCCov output")
		self.init(arguments: arguments, parser: parser)
	}

	public init(arguments: [String], parser: ArgumentParser) {
		self.arguments = arguments
		self.parser = parser
		self.versionOption = self.parser.add(option: "--version", kind: Bool.self, usage: "Prints the current version")
		self.workspaceOption = self.parser.add(option: "--workspace", kind: String.self, usage: "The path to the workspace")
		self.schemeOption = self.parser.add(option: "--scheme", kind: String.self, usage: "The scheme to be used")
	}

	// MARK: - Actions

	public func run() throws {
		do {
			let options = try self.parse()

			// version?
			if options.get(self.versionOption) == true {
				print("xccovstats version: \(self.version)")
				exit(EXIT_SUCCESS)
			}

			// Workspace and scheme?
			if let workspace = options.get(self.workspaceOption),
			let scheme = options.get(self.schemeOption) {
				print("🏃‍♀️ Running with options:")
				print("  🎛  Workspace: \(workspace)")
				print("  🎛  Scheme: \(scheme)")

				// Run the script
				runXcodeBuildProcess(workspace: workspace, scheme: scheme)
				fetchAndProcessJSON()
				displayResults()

				// Done
				exit(EXIT_SUCCESS)
			}
			else {
				print("🚒 Cannot proceed without Workspace and Scheme options")
				exit(EXIT_FAILURE)
			}
		}
		catch is ArgumentParserError {
			print("🚒 Argument Parser Error")
			exit(EXIT_FAILURE)
		}
	}

	func parse() throws -> ArgumentParser.Result {
		return try self.parser.parse(self.arguments)
	}

}

// MARK: - Private

private extension App {

	func runXcodeBuildProcess(workspace: String, scheme: String) {
		print("👩🏽‍💻 Running Xcode Build...")
		ShellCommands().runXcodebuild(workspace: workspace, scheme: scheme, sim: sim)
	}

	func fetchAndProcessJSON() {
		print("🐶 Fetching JSON...")
		let json = JSONHelper().fetchCoverageJSON()

		print("👩🏽‍💻 Processing JSON...")
		projectData = JSONHelper().processJSONtoData(json: json)
		if projectData == nil { exit(EXIT_FAILURE) }
	}

	func displayResults() {
		guard let projectData = projectData else { print("🚒 Error - no project data found"); exit(EXIT_FAILURE) }

		print("🧐 You may want to look at these files...")

		let results = ResultsHelper(project: projectData)
		results.outputResultsHeadingsWithText("MODELS & VIEW MODELS BELOW THRESHOLD")
		results.processDataToAnalysisModels()
		results.outputResultsFooter()

		print("🤓 Here are you results...")

		results.outputResultsHeadingsWithText("TYPE")
		results.outputResultsForProject()
		results.outputResultsForTargets()
		results.outputResultsForFileType(.objc)
		results.outputResultsForFileType(.swift)
		results.outputResultsForFileType(.other)
		results.outputResultsFooter()

		results.outputResultsHeadingsWithText("AREA")
		results.outputResultsForArchitecturalArea(.model)
		results.outputResultsForArchitecturalArea(.viewModel)
		results.outputResultsForArchitecturalArea(.view)
		results.outputResultsForArchitecturalArea(.helper)
		results.outputResultsForArchitecturalArea(.other)
		results.outputResultsFooter()

		print("🎉 Complete!")
		exit(EXIT_SUCCESS)
	}

}
