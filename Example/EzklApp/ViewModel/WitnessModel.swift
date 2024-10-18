import Foundation
import EzklPackage

struct WitnessModel {
    func runGenWitness() async throws -> Data {
        guard let networkPath = FileHelper.checkFileExists(fileName: "network", fileType: "ezkl"),
              let inputPath = FileHelper.checkFileExists(fileName: "input", fileType: "json") else {
            throw EzklError.InternalError("One or more files not found.")
        }

        let networkData = try Data(contentsOf: URL(fileURLWithPath: networkPath))
        let inputData =  try Data(contentsOf: URL(fileURLWithPath: inputPath))

        return try genWitness(compiledCircuit: networkData, input: inputData)
    }

    func handleEZKLError(_ error: EzklError, statusMessage: inout String) {
        switch error {
        case .InternalError(let message):
            statusMessage = "Internal Error: \(message)"
        }
    }
}
