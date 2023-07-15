import HyphenCore
import NearbyConnections
import NearbyCoreAdapter
import SwiftUI

class SwirlNearbyConnectionManager: ObservableObject {
    public static let shared: SwirlNearbyConnectionManager = .init()

    let connectionManager: ConnectionManager
    let advertiser: Advertiser
    let discoverer: Discoverer

    var myToken: String = ""
    var peerToken: String = ""

    var onMessageReceived: (String) -> Void = { _ in }

    private init() {
        connectionManager = ConnectionManager(serviceID: "at.hyphen.Swirl", strategy: .pointToPoint)
        advertiser = Advertiser(connectionManager: connectionManager)
        discoverer = Discoverer(connectionManager: connectionManager)

        connectionManager.delegate = self
        advertiser.delegate = self
        discoverer.delegate = self
    }

    func start(myToken: String, peerToken: String) {
        self.myToken = myToken
        self.peerToken = peerToken

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.advertiser.startAdvertising(using: myToken.data(using: .utf8)!) { error in
                print(error)
            }
            self.discoverer.startDiscovery { error in
                print(error)
            }
        }
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
            manager.send("HelloWorld!!!!!".data(using: .utf8)!, to: [device]) {
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

        if peerDevice == peerToken {
            discoverer.stopDiscovery()
            advertiser.stopAdvertising()
            discoverer.requestConnection(to: id, using: myToken.data(using: .utf8)!) {
                print($0)
            }
        }

        // An endpoint was found.
    }

    func discoverer(_: Discoverer, didLose _: EndpointID) {
        // A previously discovered endpoint has gone away.
    }
}
