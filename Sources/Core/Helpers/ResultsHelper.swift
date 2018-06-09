import Foundation
import Basic
import Utility

public class ResultsHelper {

	// MARK: - Properties

	let CoverageWarningLevel = 80.0
	let ColOneWidth = 64
	let ColTwoWidth = 16

	var projectData: Project?
	var analysisModels: [AnalysisModel] = []

	// MARK: - Lifecycle

	init(project: Project) {
		self.projectData = project
	}

	// MARK: - Processing

	public func processDataToAnalysisModels() {
		guard let projectData = projectData else { exit(EXIT_FAILURE) }

		// Project
		let projectCoverage = (projectData.lineCoverage * 100).roundToDecimal(2)
		let newAM = AnalysisModel(analysisType: .project, description: "Project", fileType: .other, architecturalArea: .na, coverage: projectCoverage)
		analysisModels.append(newAM)
		// Targets
		let appTargets = projectData.targets.filter { $0.name.lowercased().range(of:".app") != nil }
		for target in appTargets {
			let targetCoverage = (target.lineCoverage * 100).roundToDecimal(2)
			let newAM = AnalysisModel(analysisType: .target, description: target.name, fileType: .other, architecturalArea: .na, coverage: targetCoverage)
			analysisModels.append(newAM)
			// Files for target
			let swiftFiles = target.files.filter { $0.name.lowercased().range(of:".swift") != nil }
			for file in swiftFiles {
				let fileCoverage = (file.lineCoverage * 100).roundToDecimal(2)

				// Determine the area of the file
				let path: String = file.path.lowercased()
				var arch: ArchitecturalArea = .other
				if path.range(of:"+") != nil {
					arch = .helper
				} else if path.range(of:"viewmodel") != nil {
					arch = .viewModel
				} else if path.range(of:"model") != nil {
					arch = .model
				} else if (path.range(of:"view") != nil) || (path.range(of:"cell") != nil) {
					arch = .view
				}

				if (arch == .model || arch == .viewModel) && fileCoverage <= CoverageWarningLevel {
					let col1 = file.name.padding(toLength: ColOneWidth, withPad: " ", startingAt: 0)
					let col2 = "\(fileCoverage)%".padding(toLength: ColTwoWidth, withPad: " ", startingAt: 0)
					print("| \(col1) | \(col2) |")
				}

				let newAM = AnalysisModel(analysisType: .file, description: file.name, fileType: .swift, architecturalArea: arch, coverage: fileCoverage)
				analysisModels.append(newAM)
			}
			let objcFiles = target.files.filter { $0.name.lowercased().range(of:".m") != nil }
			for file in objcFiles {
				let fileCoverage = (file.lineCoverage * 100).roundToDecimal(2)
				let newAM = AnalysisModel(analysisType: .file, description: file.name, fileType: .objc, architecturalArea: .na, coverage: fileCoverage)
				analysisModels.append(newAM)
			}
			let otherFiles = target.files.filter { ($0.name.lowercased().range(of:".m") == nil && $0.name.lowercased().range(of:".swift") == nil) }
			for file in otherFiles {
				let fileCoverage = (file.lineCoverage * 100).roundToDecimal(2)
				let newAM = AnalysisModel(analysisType: .file, description: file.name, fileType: .other, architecturalArea: .na, coverage: fileCoverage)
				analysisModels.append(newAM)
			}
		}
	}

	// MARK: - Outputs

	public func printSeperator() {
		print("|------------------------------------------------------------------|------------------|")
	}

	public func outputResultsHeadingsWithText(_ text: String) {
		print("\n")
		print("=======================================================================================")
		let col1 = text.padding(toLength: ColOneWidth, withPad: " ", startingAt: 0)
		let col2 = "COVERAGE".padding(toLength: ColTwoWidth, withPad: " ", startingAt: 0)
		print("| \(col1) | \(col2) |")
		print("=======================================================================================")
	}

	public func outputResultsFooter() {
		print("=======================================================================================")
		print("\n")
	}

	public func outputResultsForProject() {
		let projectAM = analysisModels.filter { $0.analysisType == .project }
		if let firstProjectAM = projectAM.first {
			let col1 = "Project".padding(toLength: ColOneWidth, withPad: " ", startingAt: 0)
			let col2 = "\(firstProjectAM.coverage.roundToDecimal(2))%".padding(toLength: ColTwoWidth, withPad: " ", startingAt: 0)
			print("| \(col1) | \(col2) |")
		}
	}

	public func outputResultsForTargets() {
		printSeperator()
		let targetAM = analysisModels.filter { $0.analysisType == .target }
		for target in targetAM {
			let col1 = target.description.padding(toLength: ColOneWidth, withPad: " ", startingAt: 0)
			let col2 = "\(target.coverage.roundToDecimal(2))%".padding(toLength: ColTwoWidth, withPad: " ", startingAt: 0)
			print("| \(col1) | \(col2) |")
		}
	}

	public func outputResultsForObjc() {
		printSeperator()
	}

	public func outputResultsForFileType(_ fileType: FileType) {
		printSeperator()
		let coverageArray = analysisModels.compactMap { ($0.analysisType == .file && $0.fileType == fileType) ? $0.coverage : nil }
		let aggregate = coverageArray.average()
		let col1 = fileType.rawValue.padding(toLength: ColOneWidth, withPad: " ", startingAt: 0)
		let col2 = "\(aggregate.roundToDecimal(2))%".padding(toLength: ColTwoWidth, withPad: " ", startingAt: 0)
		print("| \(col1) | \(col2) |")
	}

	public func outputResultsForArchitecturalArea(_ architecturalArea: ArchitecturalArea) {
		let coverageArray = analysisModels.compactMap { ($0.analysisType == .file && $0.fileType == .swift && $0.architecturalArea == architecturalArea) ? $0.coverage : nil }
		let aggregate = coverageArray.average()
		let col1 = architecturalArea.rawValue.padding(toLength: ColOneWidth, withPad: " ", startingAt: 0)
		let col2 = "\(aggregate.roundToDecimal(2))%".padding(toLength: ColTwoWidth, withPad: " ", startingAt: 0)
		print("| \(col1) | \(col2) |")
	}

}
