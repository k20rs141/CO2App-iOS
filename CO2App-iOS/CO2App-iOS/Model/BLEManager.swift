//
//  BLEManager.swift
//

import CoreBluetooth
import Foundation

actor TransferService {
    //    static let serviceUUID = CBUUID(string: "E20A39F4-73F5-4BC4-A12F-17D1AD07A961")
    static var serviceUuid = CBUUID(string: "74346d48-fa0f-4c89-af07-c1c1ce0fddf8")
    //    static let characteristicUUID = CBUUID(string: "08590F7E-DB05-467E-8757-72F6FAEB13D4")
    static let locationUuid = CBUUID(string: "c607c2fb-0f19-4844-b45c-031bb05c0a50")
    static let ssidUuid = CBUUID(string: "c607c2fb-0f19-4844-b45c-031bb05c0a51")
    static let passwordUuid = CBUUID(string: "c607c2fb-0f19-4844-b45c-031bb05c0a52")
}


final class BLEManager: NSObject {
    @MainActor static let shared = BLEManager()
    private var centralManager: CBCentralManager?
    private var discoveredPeripheral: CBPeripheral?
    var peripherals: [CBPeripheral?] = []

    override init() {
        super.init()

        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }
    
}

extension BLEManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            retrievePeripheral()
        default:
            print(central.state)
        }
    }

    private func retrievePeripheral() {
        guard let centralManager = centralManager else { return }
        let connectedPeripherals: [CBPeripheral] = (centralManager.retrieveConnectedPeripherals(withServices: [TransferService.serviceUuid]))

        print("Found connected Peripherals with transfer service: %@", connectedPeripherals)

        if let connectedPeripheral = connectedPeripherals.last {
            print("Connecting to peripheral %@", connectedPeripheral)
            discoveredPeripheral = connectedPeripheral
            centralManager.connect(connectedPeripheral, options: nil)
        } else {
            centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let peripheralName: String = peripheral.name else { return }

        if peripheralName.contains("KSU CO2"), !peripherals.contains(peripheral) {
            peripherals.append(peripheral)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
        
    }
}

extension BLEManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        
    }
}
