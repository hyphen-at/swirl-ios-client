import ComposableArchitecture
import Dependencies
import SwiftUI
import SwirlBlockchain
import UIKit

public struct MakeProfile: ReducerProtocol {
    public struct State: Equatable {
        public var isLoading: Bool = false

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

        case onMakeMyCardButtonClick(Color)

        case onMakeMyCardComplete
    }

    @Dependency(\.swirlBlockchainClient) var blockchainClient

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
            case let .onMakeMyCardButtonClick(color):
                state.isLoading = true
                return .run { [state = state] dispatch in
                    var photoUrlString = ""

                    if let selectedImage = state.pfpImage {
                        let data = try await UploadPhoto.uploadImage(paramName: "file", fileName: UUID().uuidString, image: selectedImage)
                        let ipfsHash = data["IpfsHash"] as? String ?? ""

                        photoUrlString = UploadPhoto.getIpfsHashToUrl(ipfsHash).absoluteString
                    }

                    try await blockchainClient.createMyNameCard(
                        BlockchainClient.CreateMyNameCardPayload(
                            nickname: state.nickname,
                            profileImage: photoUrlString,
                            keywords: state.keywords.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
                            color: color.toHex()!,
                            twitterHandle: state.twitterHandle,
                            telegramHandle: state.telegramHandle,
                            discordHandle: state.discordHandle,
                            threadHandle: state.threadsHandle
                        )
                    )

                    await dispatch(.onMakeMyCardComplete)
                }
            default:
                return .none
            }
        }
    }

    public init() {}
}
