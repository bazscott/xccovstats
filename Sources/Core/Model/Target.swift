import Foundation

public struct Target : Decodable {
    let name: String
    let coveredLines: Int
    let lineCoverage: Double
    let executableLines: Int
    let files: [File]
}
