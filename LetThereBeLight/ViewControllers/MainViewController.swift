//
//  MainViewController.swift
//  LetThereBeLight
//
//  Created by Dean Thibault on 11/5/17.
//  Copyright © 2017 Digital Beans. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MainViewController: UIViewController {

	// The BLE service UUID
	let uuid = "FFE0"
	@IBOutlet var lightSwitch: UISwitch!
	@IBOutlet var blinkSwitch: UISwitch!
	@IBOutlet var loadingIndicator: NVActivityIndicatorView!
	
	var bluetoothIO: BluetoothIO?
	
	fileprivate func connect() {
		
		loadingIndicator.startAnimating()
		lightSwitch.isEnabled = false
		navigationItem.rightBarButtonItem?.isEnabled = false
		
		bluetoothIO = BluetoothIO(serviceUUID: uuid, delegate: self)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Let There Be Light"
		connect()
	}

	@IBAction func switchValueChanged(_ sender: Any) {

		guard let powerSwitch = sender as? UISwitch else { return }
		
		// blink switch is only enabled if light is on
		blinkSwitch.isEnabled = lightSwitch.isOn
		if !lightSwitch.isOn {
			blinkSwitch.isOn = false
		}
		
		let value = powerSwitch.isOn
		NSLog("Sending value to BLE: \(value)")
		bluetoothIO?.writeValue(value: value ? LightState.on.rawValue : LightState.off.rawValue)
	}
	
	@IBAction func blinkValueChanged(_ sender: Any) {

		guard let blinkSwitch = sender as? UISwitch else { return }
		
		let value = blinkSwitch.isOn
		NSLog("Sending value to BLE: \(value)")
		
		if lightSwitch.isOn {
			bluetoothIO?.writeValue(value: value ? LightState.blinkOn.rawValue : LightState.blinkOff.rawValue)
		}
	}
	
	@IBAction func connectAction(_ sender: Any) {
		
		connect()
	}
	
}

extension MainViewController: BluetoothIODelegate {
	func bluetoothIO(bluetoothIO: BluetoothIO, didReceiveValue value: Int8) {

		NSLog("Received value(\(value))")
	}
	
	func errorOccurred(error: String) {
		
		loadingIndicator.stopAnimating()
		let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
		let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
		alertController.addAction(action)
		navigationItem.rightBarButtonItem?.isEnabled = true
		present(alertController, animated: true)
	}
	
	func connectSuccessful() {
		
		loadingIndicator.stopAnimating()
		lightSwitch.isEnabled = true
		navigationItem.rightBarButtonItem?.isEnabled = true
	}
}

