import Foundation
import EzklPackage

struct ProofModel {
    func runGenProof(witnessJson: Data) async throws -> (vkData: Data, proofOutput: Data) {
        guard let srsPath = FileHelper.checkFileExists(fileName: "kzg", fileType: "srs"),
              let networkPath = FileHelper.checkFileExists(fileName: "network", fileType: "ezkl") else {
            throw EzklError.InternalError("One or more files not found.")
        }

        let srsData = try Data(contentsOf: URL(fileURLWithPath: srsPath))
        let networkData = try Data(contentsOf: URL(fileURLWithPath: networkPath))
        
        // Generate the PK from VK, because PK is too large to be stored in the GitHub repo
        // Usually you will be able to bundle it inside of the application
        let vkData = try genVk(compiledCircuit: networkData, srs: srsData, compressSelectors: true)
        let pkData = try genPk(vk: vkData, compiledCircuit: networkData, srs: srsData)

        let proofOutput = try prove(witness: witnessJson, pk: pkData, compiledCircuit: networkData,  srs: srsData)
        
        return (vkData, proofOutput)
    }

    func handleEZKLError(_ error: EzklError, statusMessage: inout String) {
        switch error {
        case .InternalError(let message):
            statusMessage = "Internal Error: \(message)"
        }
    }
}
