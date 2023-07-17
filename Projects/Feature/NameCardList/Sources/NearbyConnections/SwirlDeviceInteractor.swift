import Foundation
import MultipeerConnectivity
import NearbyInteraction
import SwiftUI
import SwirlModel
@_spi(HyphenInternal) import HyphenCore

class SwirlDeviceInteractor: NSObject, ObservableObject, NISessionDelegate {
    var mpc: MPCSession? = nil
    var session: NISession? = nil
    private var peerDiscoveryToken: NIDiscoveryToken? = nil
    private var connectedPeer: MCPeerID? = nil
    private var sharedTokenWithPeer = false

    @Published var peerDisplayName: String = ""

    @Published var myToken: String = ""
    @Published var peerToken: String = ""
    @Published var message: String = ""

    private var isConnecting = false

    private var myNameCard: SwirlProfile? = nil

    @Published var peerNameCard: SwirlProfile? = nil
    private var signedPayloadData: Data? = nil

    func startup(myNameCard: SwirlProfile, signaturePayload: String) {
        signedPayloadData = HyphenCryptography.signData(signaturePayload.data(using: .utf8)!)
        print("==== [SignedData] \(signedPayloadData!.hexValue)")

        self.myNameCard = myNameCard

        // Create the NISession.
        session = NISession()

        // Set the delegate.
        session?.delegate = self

        // Because the session is new, reset the token-shared flag.
        sharedTokenWithPeer = false

        // If `connectedPeer` exists, share the discovery token, if needed.
//        if connectedPeer != nil && mpc != nil {
//            if let myToken = session?.discoveryToken {
//                print("Initializing...")
//                if !sharedTokenWithPeer {
//                    shareMyDiscoveryToken(token: myToken)
//                }
//                guard let peerToken = peerDiscoveryToken else {
//                    return
//                }
//                let config = NINearbyPeerConfiguration(peerToken: peerToken)
//                session?.run(config)
//            } else {
//                fatalError("Unable to get self discovery token, is this session invalidated?")
//            }
//        } else {
//            print("Discovering Peer...")
//            startupMPC()
//        }
        startupMPC()
    }

    public func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        guard let peerToken = peerDiscoveryToken else {
            fatalError("don't have peer token")
        }

        // Find the right peer.
        let peerObj = nearbyObjects.first { obj -> Bool in
            obj.discoveryToken == peerToken
        }

        guard let nearbyObjectUpdate = peerObj else {
            return
        }

        myToken = session.discoveryToken!.description
        self.peerToken = nearbyObjectUpdate.discoveryToken.description

        if nearbyObjectUpdate.distance! < 0.2, !isConnecting {
            isConnecting = true

            mpc!.invalidate()
            session.invalidate()

            print("============ Data Connection Established")
            SwirlNearbyConnectionManager.shared.onMessageReceived = {
                self.message = $0
                self.isConnecting = false

                let peerNameCard = try! JSONDecoder().decode(SwirlProfile.self, from: self.message.data(using: .utf8)!)
                self.peerNameCard = peerNameCard

                print("=== [DataReceived] -> \(peerNameCard)")
            }

            let encodedNameCard = try! JSONEncoder().encode(myNameCard)

            SwirlNearbyConnectionManager.shared.start(
                myToken: myToken,
                peerToken: self.peerToken,
                myProfileJsonString: String(data: encodedNameCard, encoding: .utf8)!
            )
        }
//
//        print(String(format: "%0.2f m", nearbyObjectUpdate.distance!))
//        print(nearbyObjectUpdate.distance!)
    }

    func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason) {
        guard let peerToken = peerDiscoveryToken else {
            fatalError("don't have peer token")
        }
        // Find the right peer.
        let peerObj = nearbyObjects.first { obj -> Bool in
            obj.discoveryToken == peerToken
        }

        if peerObj == nil {
            return
        }

        switch reason {
        case .peerEnded:
            // The peer token is no longer valid.
            peerDiscoveryToken = nil

            // The peer stopped communicating, so invalidate the session because
            // it's finished.
            session.invalidate()

            // Restart the sequence to see if the peer comes back.
            // startup()

            // Update the app's display.
            print("Peer Ended")
        case .timeout:

            // The peer timed out, but the session is valid.
            // If the configuration is valid, run the session again.
            if let config = session.configuration {
                session.run(config)
            }
            print("Peer Timeout")
        default:
            fatalError("Unknown and unhandled NINearbyObject.RemovalReason")
        }
    }

    func sessionWasSuspended(_: NISession) {
        print("Session suspended")
    }

    func sessionSuspensionEnded(_: NISession) {
//        // Session suspension ended. The session can now be run again.
//        if let config = self.session?.configuration {
//            session.run(config)
//        } else {
//            // Create a valid configuration.
//            startup()
//        }
    }

    func session(_: NISession, didInvalidateWith _: Error) {
        // Recreate a valid session.
        // startup()
    }

    // MARK: - Discovery token sharing and receiving using MPC.

    func startupMPC() {
        if mpc == nil {
            // Prevent Simulator from finding devices.
            #if targetEnvironment(simulator)
                mpc = MPCSession(service: "swirl", identity: "at.hyphen.SWIRL-ni-sim", maxPeers: 1)
            #else
                mpc = MPCSession(service: "swirl", identity: "at.hyphen.SWIRL-ni", maxPeers: 1)
            #endif
            mpc?.peerConnectedHandler = connectedToPeer
            mpc?.peerDataHandler = dataReceivedHandler
            mpc?.peerDisconnectedHandler = disconnectedFromPeer
        }
        mpc?.invalidate()
        mpc?.start()
    }

    func connectedToPeer(peer: MCPeerID) {
        guard let myToken = session?.discoveryToken else {
            fatalError("Unexpectedly failed to initialize nearby interaction session.")
        }

        if connectedPeer != nil {
            fatalError("Already connected to a peer.")
        }

        if !sharedTokenWithPeer {
            shareMyDiscoveryToken(token: myToken)
        }

        connectedPeer = peer
        peerDisplayName = peer.displayName
    }

    func disconnectedFromPeer(peer: MCPeerID) {
        if connectedPeer == peer {
            connectedPeer = nil
            sharedTokenWithPeer = false
        }
    }

    func dataReceivedHandler(data: Data, peer: MCPeerID) {
        guard let discoveryToken = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data) else {
            fatalError("Unexpectedly failed to decode discovery token.")
        }
        peerDidShareDiscoveryToken(peer: peer, token: discoveryToken)
    }

    func shareMyDiscoveryToken(token: NIDiscoveryToken) {
        guard let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true) else {
            fatalError("Unexpectedly failed to encode discovery token.")
        }
        mpc?.sendDataToAllPeers(data: encodedData)
        sharedTokenWithPeer = true
    }

    func peerDidShareDiscoveryToken(peer: MCPeerID, token: NIDiscoveryToken) {
        if connectedPeer != peer {
            fatalError("Received token from unexpected peer.")
        }
        // Create a configuration.
        peerDiscoveryToken = token

        let config = NINearbyPeerConfiguration(peerToken: token)

        // Run the session.
        session?.run(config)
    }

    func sessionClear() {
        isConnecting = false
        SwirlNearbyConnectionManager.shared.invalidate()
        peerNameCard = nil
    }
}
