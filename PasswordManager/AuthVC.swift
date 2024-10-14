//
//  AuthVC.swift
//  Password-manager-OS
//
//  Created by Kristina Mateva on 14.10.24.
//

import Cocoa
import LocalAuthentication

class AuthVC: NSViewController {
    
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var tryAgainButton: NSButton!
    
    let context = LAContext()
    let reasonString = "Password Manager login"
    
    override func viewDidAppear() {
        super.viewDidAppear()
        getAuth()
    }
    
    @IBAction func tryAgainAction(_ sender: NSButton) {
        getAuth()
    }
    
    func getAuth() {
        animatedIndicator = true
        
        // Check for biometrics availability
        if canAuthWithBio {
            getAuthWithBio()
        } else {
            getAuthWithPassword()
        }
    }
    
    @available(macOS 10.12.2, *)
    func getAuthWithBio() {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { [weak self] success, error in
            guard let self = self else { return }
            self.animatedIndicator = false
            
            if success {
                self.goToNextVC()
            } else if let error = error {
                self.handleError(error)
            }
        }
    }

    func getAuthWithPassword() {
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reasonString) { [weak self] success, error in
            guard let self = self else { return }
            self.animatedIndicator = false
            
            if success {
                self.goToNextVC()
            } else if let error = error {
                self.handleError(error)
            }
        }
    }
    
    var canAuthWithBio: Bool {
        var authError: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError)
    }
    
    func handleError(_ error: Error) {
        switch error {
        case LAError.appCancel, LAError.userCancel:
            showTryAgainButton()
        case LAError.authenticationFailed:
            showWrongPassAlert()
        case LAError.userFallback:
            getAuthWithPassword()
        default:
            showGenericErrorAlert()
        }
    }
    
    func showGenericErrorAlert() {
        Utils.showAlert(message: "Error!", infoText: "An unexpected error occurred. Please try again.", cancelButton: false)
    }
    
    var animatedIndicator: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.animatedIndicator {
                    self.progressIndicator.startAnimation(nil)
                } else {
                    self.progressIndicator.stopAnimation(nil)
                }
            }
        }
    }
    
    func showTryAgainButton() {
        tryAgainButton.isTransparent = false
    }
    
    func showWrongPassAlert() {
        Utils.showAlert(message: "Error!", infoText: "Wrong identification", cancelButton: false)
    }
    
    func goToNextVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.performSegue(withIdentifier: Constants.MAIN_MENU_SEGUE, sender: nil)
        }
    }
}
