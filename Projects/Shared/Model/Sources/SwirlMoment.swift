import Foundation

public struct SwirlMoment: Codable, Sendable, Equatable, Hashable {
    public let id: UInt64
    public let profile: SwirlProfile

    public init(id: UInt64, profile: SwirlProfile) {
        self.id = id
        self.profile = profile
    }

    enum CodingKeys: String, CodingKey {
        case id
        case profile
    }
}
