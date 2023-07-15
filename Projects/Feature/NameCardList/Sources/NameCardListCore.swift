import ComposableArchitecture
import Dependencies
import SwiftUI
import SwirlModel
import UIKit

private var dummyProfile: SwirlProfile {
    let mockSocialHandles = [
        SwirlProfile.SocialHandle(channel: "twitter", handle: "@helloworld"),
        SwirlProfile.SocialHandle(channel: "discord", handle: "helloworld"),
        SwirlProfile.SocialHandle(channel: "telegram", handle: "helloworld"),
        SwirlProfile.SocialHandle(channel: "threads", handle: "hihi.world"),
    ]

    let mockProfile = SwirlProfile(
        nickname: "HelloAlice",
        profileImage: "https://...",
        keywords: ["aa", "Blockchain", "loves", "you"],
        color: Color(hue: Double.random(in: 0 ... 1), saturation: 0.62, brightness: 1).toHex()!,
        socialHandles: mockSocialHandles
    )

    return mockProfile
}

private let dummyList: [SwirlProfile] = [dummyProfile, dummyProfile, dummyProfile, dummyProfile]

public struct NameCardList: ReducerProtocol {
    public struct State: Equatable {
        public var isLoading: Bool = true
        public var profiles: [SwirlProfile] = dummyList

        public init() {}
    }

    public enum Action {
        case loading
        case loadingComplete

        case onNameCardClick(profile: SwirlProfile)
    }

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .loading:
                return .run { dispatch in
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    await dispatch(.loadingComplete)
                }
            case .loadingComplete:
                state.isLoading = false
                return .none
            default:
                return .none
            }
        }
    }

    public init() {}
}
