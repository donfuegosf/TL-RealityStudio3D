# Reality Studio 3D

Welcome to the **Reality Studio 3D** app, a powerful tool developed using Swift and SwiftUI, designed to enhance your experience with 3D objects through advanced features and intuitive interactions.

## Open Source Release

The initial version (V0) of the app will be available as open source starting **April 16, 2024**.
**Post-April 2024**, the project will transition to a **closed source model to further its development**.
You can preview it here: [Closed Source Reality Studio 3D on GitHub](https://github.com/AntoneseiCristian/Reality-Studio-3D-Preview-App).

## Features

**Reality Studio 3D** offers a suite of tools to manage, view, and interact with 3D models:

- **3D Object Scanning**: Capture real-world objects as 3D models using the device's camera.
<p align="center">
  <img src="https://github.com/AntoneseiCristian/Reality-Studio-3D-Preview-App/blob/main/3D%20Capture%20Example/IMG_0315.PNG" style="width: 25%;" alt="Example Image">
  <img src="https://github.com/AntoneseiCristian/Reality-Studio-3D-Preview-App/blob/main/3D%20Capture%20Example/IMG_0317.PNG" style="width: 25%;" alt="Example Image">
  <img src="https://github.com/AntoneseiCristian/Reality-Studio-3D-Preview-App/blob/main/Processed%203D%20Model/IMG_0318.PNG" style="width: 25%;" alt="Example Image">
</p>
- **AR Quick Preview**: Leverage Apple's ARKit for immediate augmented reality previews of your 3D models.
<p align="center">
  <img src="https://github.com/AntoneseiCristian/Reality-Studio-3D-Preview-App/blob/main/Processed%203D%20Model/IMG_0322.PNG" style="width: 25%;" alt="Example Image">
  <img src="https://github.com/AntoneseiCristian/Reality-Studio-3D-Preview-App/blob/main/Processed%203D%20Model/IMG_0324.PNG" style="width: 25%;" alt="Example Image">
</p>
<p align="center">
  <img src="https://github.com/AntoneseiCristian/Reality-Studio-3D-Preview-App/blob/main/3D%20Model%20in%20Real%20World/IMG_0326.PNG" style="width: 25%;" alt="Example Image">
  <img src="https://github.com/AntoneseiCristian/Reality-Studio-3D-Preview-App/blob/main/3D%20Model%20in%20Real%20World/IMG_0328.PNG" style="width: 25%;" alt="Example Image">
  <img src="https://github.com/AntoneseiCristian/Reality-Studio-3D-Preview-App/blob/main/3D%20Model%20in%20Real%20World/IMG_0329.JPG" style="width: 25%;" alt="Example Image">
</p>

- **Tracking Body Parts**
<p align="center">
  <img src="https://github.com/AntoneseiCristian/Reality-Studio-3D-Preview-App/blob/main/3D%20Model%20in%20Real%20World/IMG_0330.PNG" style="width: 25%;" alt="Example Image">
</p>
  
- **Custom AR Mode**: Place and view 3D models in your environment multiple times with a customizable placement on horizontal surfaces.
<p align="center">
  <img src="https://github.com/AntoneseiCristian/Reality-Studio-3D-Preview-App/blob/main/Simple%20VR/IMG_0332.PNG" style="width: 25%;" alt="Example Image">
</p>


- **Pick View and display in Simple AR**:
***Objects are filtred***
<p align="center">
  <img src="https://github.com/AntoneseiCristian/Reality-Studio-3D-Preview-App/blob/main/Pick%20Files%20From%20Folder/IMG_0334.PNG" style="width: 25%;" alt="Example Image">
</p>

***Added and saved in a list using UserDefaults***
<p align="center">
  <img src="https://github.com/AntoneseiCristian/Reality-Studio-3D-Preview-App/blob/main/Pick%20Files%20From%20Folder/IMG_0333.PNG" style="width: 25%;" alt="Example Image">
</p>

- **Folder Management**: Easily organize your 3D projects with capabilities to create, view, and delete folders within the app.
<p align="center">
<img src="https://github.com/AntoneseiCristian/Reality-Studio-3D/blob/main/Folder%20Management/Entry%20Point.PNG" style="width: 25%;" alt="Example Image">
<img src="https://github.com/AntoneseiCristian/Reality-Studio-3D/blob/main/Folder%20Management/Inside%20Folder.PNG" style="width: 25%;" alt="Example Image">
<img src="https://github.com/AntoneseiCristian/Reality-Studio-3D/blob/main/Folder%20Management/Delete%20File.PNG" style="width: 25%;" alt="Example Image">
</p>


## Current Status

The app is in active development, featuring various views that cater to the functionalities listed. Stay tuned for updates as we continue to expand the capabilities of **Reality Studio 3D**.

## About This README

This document provides the latest updates and the current status of the **Reality Studio 3D** app. Keep this page bookmarked for future updates and changes.
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
