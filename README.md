AR Object Viewer & Scanner

Overview

This sample code project demonstrates a comprehensive scanning workflow for capturing objects using the Object Capture API on iOS devices. It allows users to select 3D objects from their device, add them to a list, and visualize them in augmented reality (AR). 

Note: This application must be run on a physical device equipped with the necessary hardware capabilities.

Requirements

Hardware: iPhone or iPad with a LiDAR Scanner.
Chip Requirement: A14 Bionic chip or later.
Operating System: iOS or iPadOS 17 or later.
Configuration

To get started with this sample app, follow these steps:

Clone the Repository: Clone this repository to your local machine or download it as a ZIP file.
Open the Project: Open the project file in Xcode.
Connect Your Device: Connect your iOS device via USB.
Select Your Device in Xcode: Choose your connected device as the target device from the top device toolbar.
Run the Application: Hit the 'Run' button in Xcode to build and run the application on your device.
Features

Object Picking from Documents
Users can pick 3D models from their device storage using a document picker interface. The application supports multiple file formats commonly used for 3D objects. Picked objects are added to a list within the app, from which they can be selected for viewing in AR.

AR Display
Selected objects are displayed in an AR view, utilizing iOS's powerful ARKit framework. Users can interact with the 3D models in a real-world context, moving and scaling them intuitively.

Object Scanning with Object Capture
Leverage the LiDAR scanner on compatible iOS devices to scan physical objects and create detailed 3D models. This feature integrates seamlessly with the Object Capture API to provide a user-friendly experience for capturing high-quality 3D models.

Usage

Picking and Viewing Objects: Navigate to the object picking menu, select a file, and view it in augmented reality by tapping on the model in the list.
Scanning Objects: Access the scanning feature through the app's scanning menu, follow the on-screen instructions to capture the object from various angles, and generate a 3D model to be used within the app or exported for other uses.