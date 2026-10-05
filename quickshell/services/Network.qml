pragma Singleton

import Quickshell
import Quickshell.Networking

Singleton {
    id: root

    readonly property var activeDevice: {
        let fallback = null;
        for (const device of Networking.devices.values) {
            if (!device.connected)
                continue;
            if (device.type === DeviceType.Wifi || device.type === DeviceType.Wired)
                return device;
            if (!fallback)
                fallback = device;
        }
        return fallback;
    }

    readonly property var activeNetwork: {
        if (!activeDevice)
            return null;
        for (const network of activeDevice.networks.values)
            if (network.connected)
                return network;
        return null;
    }

    readonly property bool connected: activeDevice !== null

    readonly property string name: {
        if (activeNetwork && activeNetwork.name)
            return activeNetwork.name;
        if (activeDevice)
            return activeDevice.name;
        return "";
    }

    // WifiNetwork exposes signalStrength (0..1); wired counts as full.
    readonly property real strength: {
        if (!connected)
            return 0;
        if (activeDevice.type === DeviceType.Wifi && activeNetwork && activeNetwork.signalStrength !== undefined)
            return activeNetwork.signalStrength;
        return 1;
    }

    // 0 = none, 1 = weak, 2 = fair, 3 = good, 4 = strong.
    readonly property int level: !connected ? 0
        : strength < 0.25 ? 1
        : strength < 0.5 ? 2
        : strength < 0.75 ? 3
        : 4
}
