<h1 align="center">
  <a href="https://www.gini-apps.com/"><img src="https://cdn.xplace.com/companyLogo/u/e/uedrxh.png" alt="Markdownify" width="200"></a>
  <br>
  GABiometricAuthentication
  <br>
</h1>

<h4 align="center">Give your collection view the infinite scrolling behavior.</h4>

<p align="center">
  <img alt="Sponsor" src="https://img.shields.io/badge/sponsor-Gini--Apps-brightgreen.svg">
  <img alt="Version" src="https://img.shields.io/badge/pod-v2.0.1-blue.svg">
  <img alt="Author" src="https://img.shields.io/badge/author-Ido Meirov-yellow.svg">
  <img alt="Swift" src="https://img.shields.io/badge/swift-4.1%2B-orange.svg">
  <img alt="Swift" src="https://img.shields.io/badge/platform-ios-lightgrey.svg">
</p>

<p align="center">
  <kbd>
  <a href="https://www.cocoacontrols.com/controls/gainfinitecollectionkit-ios-1188a0d0-b0df-4e50-9536-65f4019b0ec0"><img src = "https://github.com/shay-somech/GABiometricAuthentication/blob/master/Documents/ScreenRecording_09-02-2018%2014:24.gif"></a>
</<kbd>
</p>

#### Table of Contents  
1. [Requirements](#requirements)
2. [Installation](#installation)
3. [How to Use](#howToUse) 

<a name="requirements"/>

# Requirements:
* iOS 9.0+ 
* Xcode 9.4+
* Swift 4.1+

<a name="installation"/>

# Installation:

### CocoaPods
CocoaPods is a dependency manager for Cocoa projects. You can install it with the following command:
```
$ gem install cocoapods
```
To integrate GABiometricAuthentication into your Xcode project using CocoaPods, specify it in your Podfile:
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
  pod 'GABiometricAuthentication'
end
```
Then, run the following command:
```
$ pod install
```

<a name="howToUse"/>

# How to Use:

### Open Registertion Popup:

#### Option 1 Use Default Size:

import "GABiometricAuthentication", then create GAFullScreenConfiguration and call to the function openRegisterForBiometricAuthentication with type "fullScrrenUI" in the GABiometricAuthentication class

```swift
import GABiometricAuthentication

let uiconfiguration = GAFullScreenUIConfiguration(titleText: NSAttributedString(string: "title"), descriptionText: NSAttributedString(string: "description"), backgroundColor: .white, centerImage: UIImage(named: "touch-id"), allowButtonConfiguration: GAFullScreenButtonConfiguration(backgroundColor: .black, textColor: .white, text: "Allow"), dontAllowButtonConfiguration: GAFullScreenButtonConfiguration(backgroundColor: .black, textColor: .white, text: "Do not Allow"))
        
let configuration = GAFullScreenConfiguration(uiConfiguration: uiconfiguration, localizedReason: "enter for password") { (result) in
            
            
        }
        
GABiometricAuthentication.openRegisterForBiometricAuthentication(usingRegisterType: .fullScrrenUI(configuration), inViewController: self)
```
#### Option 2 Custom UI:

Create object/view that implement CustomPopupUI 

```swift
import GABiometricAuthentication

class MyCustomPopupView: UIView,CustomPopupUI
{
 
 var continerView: UIView
 {
        return self
 }
    
    // MARK: - IBOutlet
    @IBOutlet weak var allowButton      : UIButton! // subview of continerView
    @IBOutlet weak var doNotAllowButton : UIButton! // subview of continerView
}
```

Then create GACustomPopupConfiguration and pass the CustomPopupUI object using "GACustomPopupUIConfiguration".
```swift

let customPopupUI = MyCustomPopupView(frame: CGRect.zero)
let uiconfiguration = GACustomPopupUIConfiguration(customPopupUI: customPopupUI, popupSize: CGSize(width: 309.0, height: 284.0))
let configuration = GACustomPopupConfiguration(uiConfiguration: uiconfiguration, localizedReason: "enter for password") { (result) in

}
        
```
To show the registration popup call to the function openRegisterForBiometricAuthentication with type customUI in the GABiometricAuthentication class

```swift
GABiometricAuthentication.openRegisterForBiometricAuthentication(usingRegisterType: .customUI(configuration), inViewController: self)
```

### Toggle Enter Biometric Local Authentication:

 call to evaluateBiometricLocalAuthentication in GABiometricAuthentication.
 pass to the function the localizedReason for using the biometric authentication and 
 the results block 
 
 ```swift
 GABiometricAuthentication.evaluateBiometricLocalAuthentication(localizedReason: "showPassword") { [weak self] (result) in
 
    guard let strongSelf = self else { return }
            
    switch result
    {
    case .success   : strongSelf.resultLabel.text = "success"
    default         : strongSelf.resultLabel.text = "failed"
    }
}
 ```
 
 ### Unlock Biometric Local Authentication:
 
 if the user try more then the available number of tries the system will lock the biometric local authentication,
 to unlock it call to unlockBiometricLocalAuthentication in GABiometricAuthentication
 
 
 ```swift
 GABiometricAuthentication.unlockBiometricLocalAuthentication(byLocalizedReason: "Access your password") { [weak self] (result) in
            
    guard let strongSelf = self else { return }
            
    switch result
    {
    case true   : strongSelf.resultLabel.text = "success"
    case false  : strongSelf.resultLabel.text = ""
    }
            
}
 ```
 
  ### Check if Biometric Local Authentication Available:
  
  to check if user can use biometric local authentication 
  ```swift
  let canUseBiometric = GABiometricAuthentication.canEvaluatePolicyDeviceOwnerAuthenticationWithBiometrics()
  ```

