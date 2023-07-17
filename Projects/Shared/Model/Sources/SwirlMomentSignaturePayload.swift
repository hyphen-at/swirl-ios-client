import Foundation

public struct SwirlMomentSignaturePayload: Codable, Sendable, Equatable, Hashable {
    public let address: String
    public let lat: Float
    public let lng: Float
    public let signature: String
    public let nonce: Int
    public let profile: SwirlProfile

    public init(address: String, lat: Float, lng: Float, signature: String, nonce: Int, profile: SwirlProfile) {
        self.address = address
        self.lat = lat
        self.lng = lng
        self.signature = signature
        self.nonce = nonce
        self.profile = profile
    }

    enum CodingKeys: String, CodingKey {
        case address
        case lat
        case lng
        case signature
        case nonce
        case profile
    }
}
