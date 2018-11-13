//
//  BluetoothIO.swift
//  LetThereBeLight
//
//  Created by Dean Thibault on 11/5/17.
//  Copyright © 2017 Digital Beans. All rights reserved.
//

import CoreBluetooth

// character data to write to BLE service characteristic
enum LightState: UInt8 {
	case off = 0x30 // turn LED off
	case on  = 0x31 // turn LED on
	case blinkOn = 0x32 // turn blink on
	case blinkOff = 0x33  // turn blink off
}

protocol BluetoothIODelegate: class {
	func bluetoothIO(bluetoothIO: BluetoothIO, didReceiveValue value: Int8)
	func errorOccurred(error: String)
	func connectSuccessful()
}

class BluetoothIO: NSObject {
	let serviceUUID: String
	
	var timer: Timer?
	weak var delegate: BluetoothIODelegate?
	
	var centralManager: CBCentralManager!
	var connectedPeripheral: CBPeripheral?
	var targetService: CBService?
	var writableCharacteristic: CBCharacteristic?
	
	let characteristicUUID = "FFE1"
	
	init(serviceUUID: String, delegate: BluetoothIODelegate?) {
		self.serviceUUID = serviceUUID
		self.delegate = delegate
		
		super.init()
		
		centralManager = CBCentralManager(delegate: self, queue: nil)
	}
	
	func writeValue(value: UInt8) {
		guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
			return
		}
		
		let data = Data(bytes: [value])
		peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
	}
	
}

extension BluetoothIO: CBCentralManagerDelegate {
	func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		peripheral.discoverServices(nil)
	}
	
	func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
		connectedPeripheral = peripheral
		
		if let connectedPeripheral = connectedPeripheral {
			connectedPeripheral.delegate = self
			centralManager.connect(connectedPeripheral, options: nil)
		}
		
		timer?.invalidate()
		stopScan()
	}
	
	@objc func stopScan() {
		centralManager.stopScan()
	}

	@objc func scanTimedOut() {
		stopScan()
		delegate?.errorOccurred(error: "Could not find BLE peripheral")
	}

	func centralManagerDidUpdateState(_ central: CBCentralManager) {
		if central.state == .poweredOn {
			centralManager.scanForPeripherals(withServices: [CBUUID(string: serviceUUID)], options: nil)

			timer?.invalidate()
			timer = Timer.scheduledTimer(timeInterval: 17, target: self, selector: #selector(scanTimedOut), userInfo: nil, repeats: false)
		}
	}
}

extension BluetoothIO: CBPeripheralDelegate {
	func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
		guard let services = peripheral.services else {
			return
		}
		
		targetService = services.first
		for service in services {
			targetService = service
			peripheral.discoverCharacteristics(nil, for: service)
		}
	}
	
	func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
		guard let characteristics = service.characteristics else {
			return
		}
		
		for characteristic in characteristics {
			if characteristic.uuid.uuidString == characteristicUUID {
				writableCharacteristic = characteristic
				peripheral.setNotifyValue(true, for: characteristic)
				delegate?.connectSuccessful()
				break
			}
		}
	}
	
	func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
		
		guard error == nil else {
			NSLog("Error: \(String(describing: error))")
			return
		}
		guard let data = characteristic.value, let delegate = delegate else {
			return
		}
		
		delegate.bluetoothIO(bluetoothIO: self, didReceiveValue: data.int8Value())
	}
	
	func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
		
		NSLog("Characteristic UUID: \(characteristic.uuid.uuidString)")
		
		guard error == nil else {
			
			NSLog("Error writing value to characteristic: \(String(describing: error))")
			return
		}
		
		NSLog("Write successful")
	}
}

