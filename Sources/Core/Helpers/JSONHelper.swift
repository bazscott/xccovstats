import Foundation

public struct JSONHelper {

	public func fetchCoverageJSON() -> String {
		let result = ShellCommands().run("xcrun xccov view Build/Logs/Test/*.xccovreport --json")
		print("🐶 Fetching JSON exit code: \(result.exitCode)")
		if result.exitCode != EXIT_SUCCESS { exit(EXIT_FAILURE) }
		return result.output
	}

	public func processJSONtoData(json: String) -> Project? {
		if let jsonData = json.data(using: .utf8) {
			let decoder = JSONDecoder()
			do {
				return try decoder.decode(Project.self, from: jsonData)
			}
			catch { print("🚒 Error decoding JSON: \(error)"); return nil }
		}
		else { print("🚒 Processing JSON failed"); return nil }
	}

}
