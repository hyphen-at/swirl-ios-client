/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 A class that manages peer discovery-token exchange over the local network by using MultipeerConnectivity.
 */

import Foundation
import MultipeerConnectivity

struct MPCSessionConstants {
    static let kKeyIdentity: String = "identity"
}

class MPCSession: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
    var peerDataHandler: ((Data, MCPeerID) -> Void)?
    var peerConnectedHandler: ((MCPeerID) -> Void)?
    var peerDisconnectedHandler: ((MCPeerID) -> Void)?
    private let serviceString: String
    private let mcSession: MCSession
    private let localPeerID = MCPeerID(displayName: UIDevice.current.name)
    private let mcAdvertiser: MCNearbyServiceAdvertiser
    private let mcBrowser: MCNearbyServiceBrowser
    private let identityString: String
    private let maxNumPeers: Int

    init(service: String, identity: String, maxPeers: Int) {
        serviceString = service
        identityString = identity
        mcSession = MCSession(peer: localPeerID, securityIdentity: nil, encryptionPreference: .required)
        mcAdvertiser = MCNearbyServiceAdvertiser(peer: localPeerID,
                                                 discoveryInfo: [MPCSessionConstants.kKeyIdentity: identityString],
                                                 serviceType: serviceString)
        mcBrowser = MCNearbyServiceBrowser(peer: localPeerID, serviceType: serviceString)
        maxNumPeers = maxPeers

        super.init()
        mcSession.delegate = self
        mcAdvertiser.delegate = self
        mcBrowser.delegate = self
    }

    // MARK: - `MPCSession` public methods.

    func start() {
        mcAdvertiser.startAdvertisingPeer()
        mcBrowser.startBrowsingForPeers()
    }

    func suspend() {
        mcAdvertiser.stopAdvertisingPeer()
        mcBrowser.stopBrowsingForPeers()
    }

    func invalidate() {
        suspend()
        mcSession.disconnect()
    }

    func sendDataToAllPeers(data: Data) {
        sendData(data: data, peers: mcSession.connectedPeers, mode: .reliable)
    }

    func sendData(data: Data, peers: [MCPeerID], mode: MCSessionSendDataMode) {
        do {
            try mcSession.send(data, toPeers: peers, with: mode)
        } catch {
            NSLog("Error sending data: \(error)")
        }
    }

    // MARK: - `MPCSession` private methods.

    private func peerConnected(peerID: MCPeerID) {
        if let handler = peerConnectedHandler {
            DispatchQueue.main.async {
                handler(peerID)
            }
        }
        if mcSession.connectedPeers.count == maxNumPeers {
            suspend()
        }
    }

    private func peerDisconnected(peerID: MCPeerID) {
        if let handler = peerDisconnectedHandler {
            DispatchQueue.main.async {
                handler(peerID)
            }
        }

        if mcSession.connectedPeers.count < maxNumPeers {
            // start()
        }
    }

    // MARK: - `MCSessionDelegate`.

    func session(_: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            peerConnected(peerID: peerID)
        case .notConnected:
            peerDisconnected(peerID: peerID)
        case .connecting:
            break
        @unknown default:
            fatalError("Unhandled MCSessionState")
        }
    }

    func session(_: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let handler = peerDataHandler {
            DispatchQueue.main.async {
                handler(data, peerID)
            }
        }
    }

    func session(_: MCSession, didReceive _: InputStream, withName _: String, fromPeer _: MCPeerID) {
        // The sample app intentional omits this implementation.
    }

    func session(_: MCSession,
                 didStartReceivingResourceWithName _: String,
                 fromPeer _: MCPeerID,
                 with _: Progress)
    {
        // The sample app intentional omits this implementation.
    }

    func session(_: MCSession,
                 didFinishReceivingResourceWithName _: String,
                 fromPeer _: MCPeerID,
                 at _: URL?,
                 withError _: Error?)
    {
        // The sample app intentional omits this implementation.
    }

    // MARK: - `MCNearbyServiceBrowserDelegate`.

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        guard let identityValue = info?[MPCSessionConstants.kKeyIdentity] else {
            return
        }
        if identityValue == identityString, mcSession.connectedPeers.count < maxNumPeers {
            browser.invitePeer(peerID, to: mcSession, withContext: nil, timeout: 10)
        }
    }

    func browser(_: MCNearbyServiceBrowser, lostPeer _: MCPeerID) {
        // The sample app intentional omits this implementation.
    }

    // MARK: - `MCNearbyServiceAdvertiserDelegate`.

    func advertiser(_: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer _: MCPeerID,
                    withContext _: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void)
    {
        // Accept the invitation only if the number of peers is less than the maximum.
        if mcSession.connectedPeers.count < maxNumPeers {
            invitationHandler(true, mcSession)
        }
    }
}
