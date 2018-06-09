import Foundation

public struct File: Decodable {
    let name: String
    let path: String
    let coveredLines: Int
    let lineCoverage: Double
    let executableLines: Int
}
