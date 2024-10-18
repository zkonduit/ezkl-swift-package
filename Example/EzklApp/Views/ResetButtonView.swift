import SwiftUI

struct ResetButtonView: View {
    @Binding var witnessOutput: Data
    @Binding var proofOutput: Data
    @Binding var verifyOutput: String
    @Binding var witnessTime: String
    @Binding var proofTime: String
    @Binding var verifyTime: String
    @Binding var isWitnessButtonEnabled: Bool
    @Binding var isProofButtonEnabled: Bool
    @Binding var isVerifyButtonEnabled: Bool
    @Binding var statusMessage: String

    var body: some View {
        Button(action: {
            resetStages()
        }) {
            Text("Reset")
                .font(.headline)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
    }

    private func resetStages() {
        witnessOutput = Data()
        proofOutput = Data()
        verifyOutput = ""
        
        witnessTime = "0.0"
        proofTime = "0.0"
        verifyTime = "0.0"
        
        isWitnessButtonEnabled = true
        isProofButtonEnabled = false
        isVerifyButtonEnabled = false
        statusMessage = "Waiting for user input"
    }
}
