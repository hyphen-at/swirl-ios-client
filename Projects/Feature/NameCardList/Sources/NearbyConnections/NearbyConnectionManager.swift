import HyphenCore
import NearbyConnections
import NearbyCoreAdapter
import SwiftUI

class SwirlNearbyConnectionManager: ObservableObject {
    public static let shared: SwirlNearbyConnectionManager = .init()

    var connectionManager: ConnectionManager? = nil
    var advertiser: Advertiser? = nil
    var discoverer: Discoverer? = nil

    var myToken: String = ""
    var peerToken: String = ""

    var myProfileJsonString: String = ""

    private var internalIndex = 1

    var onMessageReceived: (String) -> Void = { _ in }

    private init() {
        connectionManager = ConnectionManager(serviceID: "at.hyphen.Swirl", strategy: .pointToPoint)
    }

    func start(myToken: String, peerToken: String, myProfileJsonString: String) {
        self.myToken = myToken
        self.peerToken = peerToken

        self.myProfileJsonString = myProfileJsonString

        advertiser = Advertiser(connectionManager: connectionManager!)
        discoverer = Discoverer(connectionManager: connectionManager!)

        connectionManager?.delegate = self
        advertiser?.delegate = self
        discoverer?.delegate = self

        advertiser?.startAdvertising(using: myToken.data(using: .utf8)!)
        discoverer?.startDiscovery()
    }

    func invalidate() {
        advertiser?.stopAdvertising()
        discoverer?.stopDiscovery()

        advertiser = nil
        // connectionManager = nil
        discoverer = nil
    }
}

extension SwirlNearbyConnectionManager: ConnectionManagerDelegate {
    func connectionManager(
        _: ConnectionManager, didReceive _: String,
        from _: EndpointID, verificationHandler: @escaping (Bool) -> Void
    ) {
        // Optionally show the user the verification code. Your app should call this handler
        // with a value of `true` if the nearby endpoint should be trusted, or `false`
        // otherwise.
        verificationHandler(true)
    }

    func connectionManager(
        _ manager: ConnectionManager, didReceive data: Data,
        withID _: PayloadID, from device: EndpointID
    ) {
        onMessageReceived(String(data: data, encoding: .utf8)!)
        manager.disconnect(from: device)
    }

    func connectionManager(
        _: ConnectionManager, didReceive _: InputStream,
        withID _: PayloadID, from _: EndpointID,
        cancellationToken _: CancellationToken
    ) {
        // We have received a readable stream.
    }

    func connectionManager(
        _: ConnectionManager,
        didStartReceivingResourceWithID _: PayloadID,
        from _: EndpointID, at _: URL,
        withName _: String, cancellationToken _: CancellationToken
    ) {
        // We have started receiving a file. We will receive a separate transfer update
        // event when complete.
    }

    func connectionManager(
        _: ConnectionManager,
        didReceiveTransferUpdate _: TransferUpdate,
        from _: EndpointID, forPayload _: PayloadID
    ) {
        // A success, failure, cancelation or progress update.
    }

    func connectionManager(
        _ manager: ConnectionManager, didChangeTo state: ConnectionState,
        for device: EndpointID
    ) {
        switch state {
        case .connecting:
            print("CONNECTING")
        case .connected:
            print("CONNECTED")
            print("========= [DeviceConnected] \(device)")
            manager.send(myProfileJsonString.data(using: .utf8)!, to: [device]) {
                print("========= [SendComplete] \($0)")
            }
        case .disconnected:
            print("DISCONNECTED")
        case .rejected:
            print("REJECTED")
        }
    }
}

extension SwirlNearbyConnectionManager: AdvertiserDelegate {
    func advertiser(
        _: Advertiser, didReceiveConnectionRequestFrom _: EndpointID,
        with _: Data, connectionRequestHandler: @escaping (Bool) -> Void
    ) {
        // Accept or reject any incoming connection requests. The connection will still need to
        // be verified in the connection manager delegate.
        connectionRequestHandler(true)
    }
}

extension SwirlNearbyConnectionManager: DiscovererDelegate {
    func discoverer(
        _: Discoverer, didFind id: EndpointID, with context: Data
    ) {
        let peerDevice = String(data: context, encoding: .utf8)!
        print("==== [CONNECTING DEVICE] =====")

        if peerDevice == peerToken {
            discoverer?.stopDiscovery()
            advertiser?.stopAdvertising()
            discoverer?.requestConnection(to: id, using: myToken.data(using: .utf8)!) {
                print($0)
            }
        }

        // An endpoint was found.
    }

    func discoverer(_: Discoverer, didLose _: EndpointID) {
        // A previously discovered endpoint has gone away.
    }
}
