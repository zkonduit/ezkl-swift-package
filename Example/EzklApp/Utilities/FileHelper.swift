import Foundation
import EzklPackage

struct FileHelper {
    static func checkFileExists(fileName: String, fileType: String) -> String? {
        let bundle = Bundle.main
        guard let path = bundle.path(forResource: fileName, ofType: fileType) else {
            print(fileName)
            return nil
        }
        return path
    }

    static func saveJsonToFile(jsonString: String, fileName: String) throws -> String {
        let tempDir = FileManager.default.temporaryDirectory
        let filePath = tempDir.appendingPathComponent(fileName)

        do {
            try jsonString.write(to: filePath, atomically: true, encoding: .utf8)
        } catch {
            throw EzklError.InternalError("Failed to save JSON to file: \(error.localizedDescription)")
        }

        return filePath.path
    }
}
