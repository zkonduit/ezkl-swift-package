import SwiftUI
import EzklPackage

struct VerifyProofButtonView: View {
    @Binding var proofOutput: Data
    @Binding var vkData: Data
    @Binding var verifyOutput: String
    @Binding var isVerifyButtonEnabled: Bool
    @Binding var verifyStartTime: Date?
    @Binding var statusMessage: String
    @Binding var verifyTime: String

    var body: some View {
        Button(action: {
            statusMessage = "Waiting for verification to start..."
            verifyStartTime = Date()
            isVerifyButtonEnabled = false
            verifyOutput = ""
            
            Task {
                do {
                    statusMessage = "Verifying proof... please wait"
                    verifyOutput = "\(try await VerifyModel().runVerify(vkData: vkData, proofJson: proofOutput))"
                    statusMessage = "Verification complete"
                } catch let error as EzklError {
                    VerifyModel().handleEZKLError(error, statusMessage: &statusMessage)
                } catch {
                    statusMessage = "An unexpected error occurred: \(error.localizedDescription)"
                }
                isVerifyButtonEnabled = true
                verifyStartTime = nil
            }
        }) {
            Text("Verify Proof")
                .font(.headline)
                .padding()
                .background(isVerifyButtonEnabled ? Color.red : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
        .disabled(!isVerifyButtonEnabled)
        .accessibilityLabel("Verify Proof")
        
        Text("Verify Output: \(verifyOutput)")
            .padding(.bottom, 8)
        
        Text("Verify Time: \(verifyTime)")
            .padding(.bottom, 16)
    }
}
