import SwiftUI

struct ContentView: View {
    @State private var vkData: Data = Data()
    @State private var witnessOutput: Data = Data()
    @State private var proofOutput: Data = Data()
    @State private var verifyOutput: String = ""
    
    @State private var witnessTime: String = "0.0"
    @State private var proofTime: String = "0.0"
    @State private var verifyTime: String = "0.0"
    
    @State private var isWitnessButtonEnabled: Bool = true
    @State private var isProofButtonEnabled: Bool = false
    @State private var isVerifyButtonEnabled: Bool = false
    
    @State private var witnessStartTime: Date? = nil
    @State private var proofStartTime: Date? = nil
    @State private var verifyStartTime: Date? = nil

    @State private var statusMessage: String = "Waiting for user input"


    var body: some View {
        VStack {
            GenerateWitnessButtonView(
                witnessOutput: $witnessOutput,
                isWitnessButtonEnabled: $isWitnessButtonEnabled,
                isProofButtonEnabled: $isProofButtonEnabled,
                isVerifyButtonEnabled: $isVerifyButtonEnabled,
                witnessStartTime: $witnessStartTime,
                statusMessage: $statusMessage,
                witnessTime: $witnessTime

            )

            GenerateProofButtonView(
                witnessOutput: $witnessOutput,
                vkData: $vkData,
                proofOutput: $proofOutput,
                isProofButtonEnabled: $isProofButtonEnabled,
                isVerifyButtonEnabled: $isVerifyButtonEnabled,
                proofStartTime: $proofStartTime,
                statusMessage: $statusMessage,
                proofTime: $proofTime
            )
            
            VerifyProofButtonView(
                proofOutput: $proofOutput,
                vkData: $vkData,
                verifyOutput: $verifyOutput,
                isVerifyButtonEnabled: $isVerifyButtonEnabled,
                verifyStartTime: $verifyStartTime,
                statusMessage: $statusMessage,
                verifyTime: $verifyTime
            )

            // Status message display
            Text("Status: \(statusMessage)")
                .font(.subheadline)
                .padding()
                .accessibilityLabel("Status")
            
            ResetButtonView(
                witnessOutput: $witnessOutput,
                proofOutput: $proofOutput,
                verifyOutput: $verifyOutput,
                witnessTime: $witnessTime,
                proofTime: $proofTime,
                verifyTime: $verifyTime,
                isWitnessButtonEnabled: $isWitnessButtonEnabled,
                isProofButtonEnabled: $isProofButtonEnabled,
                isVerifyButtonEnabled: $isVerifyButtonEnabled,
                statusMessage: $statusMessage
            )
        }
        // Timer updates
        .onReceive(Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()) { _ in
            if let startTime = witnessStartTime {
                witnessTime = String(format: "%.3f", Date().timeIntervalSince(startTime)) + " seconds"
            }
            if let startTime = proofStartTime {
                proofTime = String(format: "%.3f", Date().timeIntervalSince(startTime)) + " seconds"
            }
            if let startTime = verifyStartTime {
                verifyTime = String(format: "%.3f", Date().timeIntervalSince(startTime)) + " seconds"
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
