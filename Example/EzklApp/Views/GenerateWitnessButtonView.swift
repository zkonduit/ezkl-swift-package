import SwiftUI
import EzklPackage

struct GenerateWitnessButtonView: View {
    @Binding var witnessOutput: Data
    @Binding var isWitnessButtonEnabled: Bool
    @Binding var isProofButtonEnabled: Bool
    @Binding var isVerifyButtonEnabled: Bool
    @Binding var witnessStartTime: Date?
    @Binding var statusMessage: String
    @Binding var witnessTime: String

    var body: some View {
        Button(action: {
            statusMessage = "Waiting for witness generation to start..."
            witnessStartTime = Date()
            isWitnessButtonEnabled = false
            isProofButtonEnabled = false
            isVerifyButtonEnabled = false
            witnessOutput = Data()
            Task {
                do {
                    statusMessage = "Generating witness... please wait"
                    witnessOutput = try await WitnessModel().runGenWitness()
                    statusMessage = "Witness Output size: \(witnessOutput.count) bytes"
                    isProofButtonEnabled = true
                    isVerifyButtonEnabled = false
                } catch let error as EzklError {
                    WitnessModel().handleEZKLError(error, statusMessage: &statusMessage)
                } catch {
                    statusMessage = "An unexpected error occurred: \(error.localizedDescription)"
                }
                isWitnessButtonEnabled = true
                witnessStartTime = nil
            }
        }) {
            Text("Generate Witness")
                .font(.headline)
                .padding()
                .background(isWitnessButtonEnabled ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
        .disabled(!isWitnessButtonEnabled)
        .accessibilityLabel("Generate Witness")
        
        Text(witnessOutput.count > 400 ? "Witness Output Size: \(witnessOutput.count) bytes" : (witnessOutput.count == 0 ? "No Witness Yet" : "Witness Output: \(witnessOutput)"))
            .padding(.bottom, 8)
        
        Text("Witness Generation Time: \(witnessTime)")
            .padding(.bottom, 16)
    }
}
