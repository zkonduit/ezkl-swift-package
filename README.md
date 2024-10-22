# EZKL iOS Package

Welcome to the **EZKL iOS Package**! This repository provides a Swift Package for integrating the [EZKL](https://github.com/zkonduit/ezkl) library into your iOS applications using Swift Package Manager. With this package, you can utilize EZKL's zero-knowledge proof capabilities directly within your Xcode projects.

> **Note:** This repository is an experimental project and should not be used in production environments.

---

## Overview

This package is an iOS port of the EZKL library, which allows you to generate and verify zero-knowledge proofs (ZKPs) for neural networks. It provides Swift bindings to the core EZKL functionalities, enabling you to:

- **Generate Witnesses**: Use `genWitness` to generate a witness for a given neural network and input data.
- **Generate Proofs**: Use `prove` to generate a ZKP based on the witness and circuit.
- **Verify Proofs**: Use `verify` to verify the generated proof against the circuit and input.
- Other functionalities useful with EZKL.
 
You can learn more about EZKL and about other capabilities at [ezkl.xyz](https://ezkl.xyz).

---

## Example App

An example iOS application demonstrating how to use EZKL within an iOS app is available in the [Example](Example) directory.
 
<img src="docs/sample-app.png" alt="Sample App Screenshot" width="20%"/>

---

## Installation

### Steps to Install the Package

**Add the package using Swift Package Manager:**

   - In your Xcode project, go to **File** > **Add Packages...**
   - Click on **Add from Github...**
   - Paste the URL of this repository and make sure to select the appropriate branch, such as `main`.
   - Xcode will prompt you to select the **Targets** to add the package to.
   - Once Xcode has added the package, you can use it as `EzklPackage`.

---

## Requirements

- **Xcode**: Version 12 or later.
- **Swift**: Version 5.3 or later.
- **Computer**: ARM based Apple MacBook (_XCode_ only runs on _macOS_).


 > To develop on Intel x86 MacBook, please build the library manually using the instructions at the bottom.

---

## Usage

### Initial Setup

Before using the EZKL functions in your app, you need to perform some initial setup using the EZKL CLI on your development machine or server:

1. **Compile the Neural Network Circuit:**

   - Use the [EZKL CLI](https://docs.ezkl.xyz/getting_started/) to compile your `.onnx` neural network model into a `.ezkl` circuit file.

2. **Generate Supporting Files:**

   - **Settings File**: Generate the settings file required for the circuit.
   - **Structured Reference String (SRS)**: Obtain the SRS, which is necessary for proof generation and verification.
   - (Optional) **Proving Key (PK) and Verification Key (VK)**: Generate the PK and VK using the SRS.

3. **Bundle the Files in Your App:**

   - Include the generated `.ezkl` circuit file, settings, SRS, and optionally PK, and VK in your Xcode project, ensuring they are accessible at runtime.

For more detailed instructions on using the EZKL CLI and generating the necessary files, refer to the [EZKL Documentation](https://docs.ezkl.xyz/getting_started/).

### Using the Package in Your Code

Import the EZKL module in your Swift files:

```swift
import EzklPackage
```

#### Generating a Witness

```swift
let inputData = /* Your input data as Data bytes */
let compiledCircuitData = /* Data representation of your compiled model */

EzklPackage.genWitness(
    compiledCircuit: compiledCircuitData,
    input: witnessData
) { result in
    switch result {
    case .success(let witnessData):
        // Use the witnessData for proof generation
    case .failure(let error):
        // Handle error
    }
}
```

#### Generating a Proof

```swift
let witnessData = /* The witness Data generated earlier */
let pkData = /* Data representation of your proving key */
let srsData = /* Data representation of your SRS */

EzklCore.prove(
    witness: witnessData,
    pk: pkData,
    compiledCircuit: compiledCircuitData,
    srs: srsData
) { result in
    switch result {
    case .success(let proofData):
        // Use the proofData as needed
    case .failure(let error):
        // Handle error
    }
}
```

#### Verifying a Proof

```swift
let proofData = /* The proof Data generated earlier */
let settingsData = /* The settings Data bytes for your circuit */
let vkData = /* Data representation of your verification key */
let srsData = /* Data representation of your SRS */

EzklCore.verify(
    proof: proofData,
    vk: vkData,
    settings: settingsData,
    srs: srsData
) { result in
    switch result {
    case .success(let isValid):
        if isValid {
            // Proof is valid
        } else {
            // Proof is invalid
        }
    case .failure(let error):
        // Handle error
    }
}
```

---

## Important Notes

- **Data Formats:**

  - **Input and Settings:** Should be Json files provided as binary 'Data' bytes.
  - **Circuit, PK, VK, SRS:** Should be loaded as binary `Data`.

- **EZKL CLI Usage:**

  - The EZKL CLI is used to prepare necessary files (circuit, settings, keys, SRS) before using the package.
  - For more information on using the EZKL CLI, refer to the [EZKL Documentation](https://ezkl.xyz).

---

## Regenerating the Package

The package is built from the Rust EZKL library fork at [ezkl](https://github.com/zkonduit/ezkl) library repository. If you wish to regenerate the bindings manually:

1. **Clone the Porter Repository:**

   ```bash
   git clone https://github.com/zkonduit/ezkl
   ```

2. **Install Prerequisites:**

    Ensure that you have **Rust** and **Cargo** installed on your machine.

3. **(Optional) Enabled x86 Mac Simulator**
   - Open the `src/bin/ios_gen_bindings.rs` file.
   - Locate the line that contains `vec!["aarch64-apple-ios-sim"],`.
   - Comment out that line and uncomment the line immediately following it.

4. **Generate iOS Bindings:**
   In your terminal, execute the following command to generate the bindings:

   ```bash
   cargo run --bin ios_gen_bindings --features "ios-bindings uuid camino uniffi_bindgen" --no-default-features
     ```

   - After successful execution, the generated bindings will be located at `build/EzklCoreBindings`.
   
5. **Update Swift Package**

    Replace the existing `EzklCoreBindings` folder inside the Swift Package’s `Sources` directory with the newly generated version.

