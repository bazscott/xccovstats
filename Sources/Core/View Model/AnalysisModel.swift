import Foundation

public enum AnalysisType: String {
    case project = "Project"
    case target = "Target"
    case file = "File"
}

public enum ArchitecturalArea: String {
    case viewModel = "View Model"
    case model = "Model"
    case view = "View"
    case helper = "Helper"
    case other = "Other"
    case na = "Not applicable"
}

public enum FileType: String {
    case swift = "Swift"
    case objc = "Obj-C"
    case other = "Other"
}

public struct AnalysisModel {
    let analysisType: AnalysisType
    let description: String
    let fileType: FileType
    let architecturalArea: ArchitecturalArea
    let coverage: Double
}
