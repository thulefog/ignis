# ignis
This is a simple, single view iOS application that illustrates setting up an iOS device such as an old iPhone to broadcast as a beacon, discoverable within a BLE range for which that device version is capable.

# Bluetooth Low Energy 

The following key design and implementation aspects are worth noting in the context of brining up a simple beacon.

This key in the info.plist is important to grease the wheels with CoreBluetooth.

* NSBluetoothPeripheralUsageDescription

Implemening against these delegates is important; notable is getting the device to act as a Peripheral to broadcast and, in turn, behave as a beacon.

- CLLocationManagerDelegate
- CBCentralManagerDelegate
- CBPeripheralManagerDelegate
- CBPeripheralDelegate

# Verify

This open source tool written in Objective-C for OSX was helping in getting the application running to the point that my old iPhone could be verified visible as a running BLE Beacon.

https://github.com/mlwelles/BeaconScanner.git

Once the beacon was indepedently verified by the tool above, I plugged in the UUID and necessary boilerplate code to this iOS application.

https://github.com/thulefog/whereclosest.git

The four state transitions below are described as:

* old phone acting as beacon located basically touching newer phone

* old phone acting as beacon moved about 12 inches away from newer phone

* old phone acting as beacon moved into next room but still in line of sight of newer phone

* after application exit, so old phone is no longer acting as a beacon

See below, debug area, console output:

~~~
,,,
Beacon range: immediate
Beacon range: immediate
...
Beacon range: near
Beacon range: near
...
Beacon range: far
Beacon range: far
...
Beacon range: unknown
Beacon range: unknown
~~~