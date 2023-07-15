import Foundation

public struct SwirlProfile: Codable, Sendable, Equatable, Hashable {
    public let nickname: String
    public let profileImage: String
    public let keywords: [String]
    public let color: String
    public let socialHandles: [SocialHandle]

    public init(nickname: String, profileImage: String, keywords: [String], color: String, socialHandles: [SocialHandle]) {
        self.nickname = nickname
        self.profileImage = profileImage
        self.keywords = keywords
        self.color = color
        self.socialHandles = socialHandles
    }

    enum CodingKeys: String, CodingKey {
        case nickname
        case profileImage
        case keywords
        case color
        case socialHandles
    }

    public struct SocialHandle: Codable, Sendable, Equatable, Hashable {
        public let channel: String
        public let handle: String

        public init(channel: String, handle: String) {
            self.channel = channel
            self.handle = handle
        }

        enum CodingKeys: String, CodingKey {
            case channel
            case handle
        }
    }
}
