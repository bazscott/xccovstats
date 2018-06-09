import Foundation

public struct Project: Decodable {
    let coveredLines: Int
    let lineCoverage: Double
    let executableLines: Int
    let targets: [Target]
}
