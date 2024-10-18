import SwiftUI
import EzklPackage

struct GenerateProofButtonView: View {
    @Binding var witnessOutput: Data
    @Binding var vkData: Data
    @Binding var proofOutput: Data
    @Binding var isProofButtonEnabled: Bool
    @Binding var isVerifyButtonEnabled: Bool
    @Binding var proofStartTime: Date?
    @Binding var statusMessage: String
    @Binding var proofTime: String

    var body: some View {
        Button(action: {
            statusMessage = "Waiting for proof generation to start..."
            proofStartTime = Date()
            isProofButtonEnabled = false
            isVerifyButtonEnabled = false
            proofOutput = Data()
            
            Task {
                do {
                    statusMessage = "Generating proof... please wait"
                    let result = try await ProofModel().runGenProof(witnessJson: witnessOutput)
                    vkData = result.vkData
                    proofOutput = result.proofOutput
                    statusMessage = "Proof generated. Output size: \(proofOutput.count) bytes"
                    isVerifyButtonEnabled = true
                } catch let error as EzklError {
                    ProofModel().handleEZKLError(error, statusMessage: &statusMessage)
                } catch {
                    statusMessage = "An unexpected error occurred: \(error.localizedDescription)"
                }
                proofStartTime = nil
                isProofButtonEnabled = true
            }
        }) {
            Text("Generate Proof")
                .font(.headline)
                .padding()
                .background(isProofButtonEnabled ? Color.green : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
        .disabled(!isProofButtonEnabled)
        .accessibilityLabel("Generate Proof")
        
        Text(proofOutput.count > 400 ? "Proof Output Size: \(proofOutput.count) bytes" : (proofOutput.count == 0 ? "No Proof Yet" : "Proof Output: \(proofOutput)"))
            .padding(.bottom, 8)
        
        Text("Proof Generation Time: \(proofTime)")
            .padding(.bottom, 16)
        
    }
}
