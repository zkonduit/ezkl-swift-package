import Foundation
import EzklPackage

struct VerifyModel {
    func runVerify(vkData: Data, proofJson: Data) async throws -> Bool {
        guard let srsPath = FileHelper.checkFileExists(fileName: "kzg", fileType: "srs"),
              let settingsPath = FileHelper.checkFileExists(fileName: "settings", fileType: "json") else {
            throw EzklError.InternalError("One or more files not found.")
        }

        let srsData = try Data(contentsOf: URL(fileURLWithPath: srsPath))
        let settingsJson = try Data(contentsOf: URL(fileURLWithPath: settingsPath))

        return try verify(proof: proofJson, vk: vkData, settings: settingsJson, srs: srsData)
    }

    func handleEZKLError(_ error: EzklError, statusMessage: inout String) {
        switch error {
        case .InternalError(let message):
            statusMessage = "Internal Error: \(message)"
        }
    }
}
