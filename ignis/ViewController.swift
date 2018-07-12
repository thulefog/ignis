//
//  ViewController.swift
//  ignis
//
//  Created by John Matthew Weston on 7/11/18.
//  Copyright © 2018 John Matthew Weston. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class ViewController: UIViewController, CLLocationManagerDelegate, CBCentralManagerDelegate,
                      CBPeripheralManagerDelegate, CBPeripheralDelegate
{
    var centralManager = CBCentralManager()
    var peripheralManager : CBPeripheralManager?
    
    var beaconRegion : CLBeaconRegion!
    var beaconPeripheralData: NSDictionary!

    let proximityUUID = UUID(uuidString: "EFF1456E-F28F-4EAC-8D04-738E73EACEDF")
    let beaconMajor : CLBeaconMajorValue = 100
    let beaconMinor : CLBeaconMinorValue = 1
    let beaconID = "com.aquavitdesigns.ignis.BeaconRegion"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        initLocalBeacon()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initLocalBeacon() {
        if beaconRegion != nil {
            stopLocalBeacon()
        }
        
        let localBeaconUUID = proximityUUID

        let uuid = UUID(uuidString: localBeaconUUID!.uuidString)!
        beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: beaconMajor, minor: beaconMinor, identifier: beaconID)
        
        beaconPeripheralData = beaconRegion.peripheralData(withMeasuredPower: nil)
        peripheralManager = CBPeripheralManager(delegate: self as! CBPeripheralManagerDelegate, queue: nil, options: nil)
    }

    func stopLocalBeacon() {
        peripheralManager?.stopAdvertising()
        peripheralManager = nil
        beaconPeripheralData = nil
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print( "CoreBluetooth BLE hardware state \(central.state)" )
        switch (central.state){
            
        case CBManagerState.poweredOff:
            print("powered off")
            break;
            
        case CBManagerState.unauthorized:
            print("unauthorized")
            break
            
        case CBManagerState.unknown:
            print("unknown");
            break
            
        case CBManagerState.poweredOn:
            print("powered on and ready")
            break;
            
        case CBManagerState.resetting:
            print("resetting")
            break;
            
        case CBManagerState.unsupported:
            print("unsupported");
            break
    }

    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager,
                                              error: NSError?)
    {
        if error == nil{
            print("Successfully started advertising our beacon data")
            
            let message = "Successfully set up your beacon. " +
            "The unique identifier of our service is: \(proximityUUID!.uuidString)"
            
            print(message)
            
        }
        else
        {
            print("Failed to advertise our beacon. Error = \(error)")
        }
        
        }
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        print("The peripheral state is \(peripheral.state.rawValue)" )
        switch peripheral.state{
            
        case .unknown:
            print("Unknown")
        //NOTE: UI versus background thread issue trying to use this to convey state change:
        //      self.view.backgroundColor = UIColor.darkGray
        case .resetting:
            print("Resetting")
        case .unsupported:
            print("Unsupported")
        case .unauthorized:
            print("Unauthorized")
        case .poweredOff:
            print("Powered off")
            peripheralManager!.stopAdvertising()
        case .poweredOn:
            print("Powered on")
            peripheralManager!.startAdvertising(beaconPeripheralData as! [String: AnyObject]!)
            
        }
    }
    
}
