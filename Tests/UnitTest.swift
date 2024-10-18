import XCTest
@testable import EzklPackage

class Tests: XCTestCase {
    var witnessOutput: Data = Data()
    var vkData: Data = Data()
    var proofOutput: Data = Data()

    // Test 1: Test genWitness with valid input
    func testGenWitnessWithValidInput() async throws {
        // Set up the file paths (assuming correct test files are available in the bundle)
        guard let inputPath = Bundle.module.path(forResource: "input", ofType: "json"),
              let compiledCircuitPath = Bundle.module.path(forResource: "network", ofType: "ezkl") else {
            XCTFail("Required files not found in the bundle")
            return
        }

        // Read the file contents as Data and Strings
        let inputData = try Data(contentsOf: URL(fileURLWithPath: inputPath))
        let compiledCircuitData = try Data(contentsOf: URL(fileURLWithPath: compiledCircuitPath))

        // Run the function with the file contents as arguments
        do {
            witnessOutput = try genWitness(compiledCircuit: compiledCircuitData, input: inputData)
            XCTAssertFalse(witnessOutput.isEmpty, "Witness should be generated")
        } catch {
            XCTFail("genWitness failed with error: \(error)")
        }
    }

    // Runs prove with valid witness
    func proveWithValidWitness() throws {
        // Ensure the witness output is available
        guard !witnessOutput.isEmpty else {
            XCTFail("Witness output is not available from the previous step")
            return
        }

        // Set up the file paths
        guard let compiledCircuitPath = Bundle.module.path(forResource: "network", ofType: "ezkl"),
              let srsPath = Bundle.module.path(forResource: "kzg", ofType: "srs") else {
            XCTFail("Required files not found in the bundle")
            return
        }

        // Read the file contents as Data
        let compiledCircuitData = try Data(contentsOf: URL(fileURLWithPath: compiledCircuitPath))
        let srsData = try Data(contentsOf: URL(fileURLWithPath: srsPath))

        // Generate the VK
        do {
            vkData = try genVk(compiledCircuit: compiledCircuitData, srs: srsData, compressSelectors: true)
        } catch {
            XCTFail("prove failed with error: \(error)")
        }

        guard let pkData = try? genPk(vk: vkData, compiledCircuit: compiledCircuitData, srs: srsData) else {
            XCTFail("prove failed: failed to generate the Pk")
            return
        }

        // Run the function with the witness output and file contents
        do {
            proofOutput = try prove(witness: witnessOutput, pk: pkData, compiledCircuit: compiledCircuitData, srs: srsData)
            XCTAssertFalse(proofOutput.isEmpty, "Proof should be generated")
        } catch {
            XCTFail("prove failed with error: \(error)")
        }
    }

    // Runs verify with valid proof
    func verifyWithValidProof() throws {
        // Ensure the proof output is available
        guard !proofOutput.isEmpty else {
            XCTFail("Proof output is not available from the previous step")
            return
        }

        // Set up the file paths
        guard let settingsPath = Bundle.module.path(forResource: "settings", ofType: "json"),
              let srsPath = Bundle.module.path(forResource: "kzg", ofType: "srs") else {
            XCTFail("Required files not found in the bundle")
            return
        }

        // Read the file contents as Data and Strings
        let settingsJson = try Data(contentsOf: URL(fileURLWithPath: settingsPath))
        let srsData = try Data(contentsOf: URL(fileURLWithPath: srsPath))

        // Run the function with the proof output and file contents
        do {
            let verificationResult = try verify(proof: proofOutput, vk: vkData, settings: settingsJson, srs: srsData)
            XCTAssertTrue(verificationResult, "Proof should be verified successfully")
        } catch {
            XCTFail("verify failed with error: \(error)")
        }
    }

    // End-to-end test that chains all steps together
    func testEndToEndProcess() async throws {
        try await testGenWitnessWithValidInput()
        try proveWithValidWitness()
        try verifyWithValidProof()
    }
}
