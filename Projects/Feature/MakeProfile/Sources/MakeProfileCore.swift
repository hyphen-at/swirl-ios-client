import ComposableArchitecture
import Dependencies
import UIKit

public struct MakeProfile: ReducerProtocol {
    public struct State: Equatable {
        public var nickname: String = ""
        public var twitterHandle: String = ""
        public var discordHandle: String = ""
        public var telegramHandle: String = ""
        public var threadsHandle: String = ""
        public var keywords: String = ""
        public var pfpImage: UIImage? = nil

        public var isValid: Bool {
            let isNameValid = !nickname.isEmpty
            let handleValid = [twitterHandle, discordHandle, telegramHandle, threadsHandle].filter { $0.isEmpty }.count < 4
            let keywordsValid = !keywords.isEmpty

            return isNameValid && handleValid && keywordsValid
        }

        public init() {}
    }

    public enum Action {
        case updateNickname(String)
        case updateTwitterHandle(String)
        case updateDiscordHandle(String)
        case updateTelegramHandle(String)
        case updateThreadsHandle(String)
        case updateKeywords(String)
        case updatePfpImage(UIImage?)

        case close
    }

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .updateNickname(nickname):
                state.nickname = nickname
                return .none
            case let .updateTwitterHandle(twitterHandle):
                state.twitterHandle = twitterHandle
                return .none
            case let .updateDiscordHandle(discordHandle):
                state.discordHandle = discordHandle
                return .none
            case let .updateTelegramHandle(telegramHandle):
                state.telegramHandle = telegramHandle
                return .none
            case let .updateThreadsHandle(threadsHandle):
                state.threadsHandle = threadsHandle
                return .none
            case let .updateKeywords(keywords):
                state.keywords = keywords
                return .none
            case let .updatePfpImage(pfpImage):
                state.pfpImage = pfpImage
                return .none
            default:
                return .none
            }
        }
    }

    public init() {}
}
