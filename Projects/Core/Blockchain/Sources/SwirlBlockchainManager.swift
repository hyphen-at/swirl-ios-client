import Flow
import Foundation
import HyphenAuthenticate
import HyphenCore
import HyphenFlow
import SwirlModel

final class SwirlBlockchainManager: NSObject {
    static let shared: SwirlBlockchainManager = .init()

    var flowAccount: Flow.Account? = nil

    private var myNameCard: SwirlProfile? = nil

    var swirlContractAddress: String {
        if Hyphen.shared.network == .testnet {
            "0x5969d51aa05825c4"
        } else {
            "0xed00d8ac249ee4b6"
        }
    }

    var nonFungibleTokenAddress: String {
        if Hyphen.shared.network == .testnet {
            "0x631e88ae7f1d7c20"
        } else {
            "0x1d7e57aa55817448"
        }
    }

    override private init() {
        if Hyphen.shared.network == .testnet {
            flow.configure(chainID: .testnet)
        } else {
            flow.configure(chainID: .mainnet)
        }
    }

    func loadAccount() async throws {
        print("===== [SwirlBlockchainManager] loading account...")

        let hyphenAccount = try await HyphenAuthenticate.shared.getAccount()

        let account = try await flow.getAccountAtLatestBlock(address: Flow.Address(hex: hyphenAccount.addresses.first!.address))
        flowAccount = account

        print("===== [SwirlBlockchainManager] loading account done. Flow account address -> \(flowAccount!.address.hex)")
    }

    func getCachedAccountAddress() -> String {
        flowAccount!.address.hex
    }

    func getMyNameCard() async throws -> SwirlProfile? {
        print("===== [SwirlBlockchainManager] get my name card...")
        if myNameCard != nil {
            return myNameCard
        }

        let script = Flow.Script(text: """
        import SwirlNametag from \(swirlContractAddress)

        /// Retrieve the SwirlNametag.Profile from the given address.
        /// If nametag doesn't exist on the address, it returns nil.
        pub fun main(address: Address): SwirlNametag.Profile? {
            let account = getAccount(address)

            if let collection = account.getCapability(SwirlNametag.CollectionPublicPath).borrow<&{SwirlNametag.SwirlNametagCollectionPublic}>() {
                let tokenIDs = collection.getIDs()
                if tokenIDs.length == 0 {
                    return nil
                }
                let nft = collection.borrowSwirlNametag(id: tokenIDs[0])!
                let metadata = nft.resolveView(Type<SwirlNametag.Profile>())!

                return metadata as? SwirlNametag.Profile ?? panic("invalid resolveView implementation on SwirlNametag")
            }
            // nametag NFT not found
            return nil
        }

        """)

        let result = try await flow.executeScriptAtLatestBlock(
            script: script,
            arguments: [
                .address(flowAccount!.address),
            ]
        )
        let decodeResult: SwirlProfile? = try result.decode()
        myNameCard = decodeResult

        return decodeResult
    }

    func getNameCardList() async throws -> [SwirlProfile] {
        let script = Flow.Script(text: """
        import SwirlNametag from \(swirlContractAddress)
        import SwirlMoment from \(swirlContractAddress)

        /// Retrieve the SwirlNametag.Profile from the given address.
        /// If nametag doesn't exist on the address, it returns nil.
        pub fun main(address: Address): [SwirlNametag.Profile] {
            let account = getAccount(address)
            let profiles: [SwirlNametag.Profile] = []

            if let collection = account.getCapability(SwirlMoment.CollectionPublicPath).borrow<&{SwirlMoment.SwirlMomentCollectionPublic}>() {
                for tokenID in collection.getIDs() {
                    let nft = collection.borrowSwirlMoment(id: tokenID)!
                    let metadata = nft.resolveView(Type<SwirlNametag.Profile>())!

                    let profile = metadata as? SwirlNametag.Profile ?? panic("invalid resolveView implementation on SwirlNametag")
                    profiles.append(profile)
                }
            }
            return profiles
        }
        """)

        let result = try await flow.executeScriptAtLatestBlock(
            script: script,
            arguments: [
                .address(flowAccount!.address),
            ]
        )

        let decodeResult: [SwirlProfile] = try result.decode()
        return decodeResult
    }

    func getMomentList() async throws -> [SwirlMoment] {
        let script = Flow.Script(text: """
        import SwirlNametag from \(swirlContractAddress)
        import SwirlMoment from \(swirlContractAddress)

        pub struct MomentInfo {
            pub let id: UInt64
            pub let profile: SwirlNametag.Profile
            pub let location: SwirlMoment.Coordinate
            pub let mintedAt: UFix64

            init(id: UInt64, profile: SwirlNametag.Profile, location: SwirlMoment.Coordinate, mintedAt: UFix64) {
                self.id = id
                self.profile = profile
                self.location = location
                self.mintedAt = mintedAt
            }
        }

        /// Retrieve the SwirlNametag.Profile from the given address.
        /// If nametag doesn't exist on the address, it returns nil.
        pub fun main(address: Address): [MomentInfo] {
            let account = getAccount(address)
            let moments: [MomentInfo] = []

            if let collection = account.getCapability(SwirlMoment.CollectionPublicPath).borrow<&{SwirlMoment.SwirlMomentCollectionPublic}>() {
                for tokenID in collection.getIDs() {
                    let nft = collection.borrowSwirlMoment(id: tokenID)!
                    moments.append(MomentInfo(id: tokenID, profile: nft.profile(), location: nft.location, mintedAt: nft.mintedAt))
                }
            }
            return moments
        }

        """)

        let result = try await flow.executeScriptAtLatestBlock(
            script: script,
            arguments: [
                .address(flowAccount!.address),
            ]
        )

        let decodeResult: [SwirlMoment] = try result.decode()
        return decodeResult
    }

    func createMyNameCard(
        nickname: String,
        profileImage: String,
        keywords: [String],
        color: String,
        twitterHandle: String?,
        telegramHandle: String?,
        discordHandle: String?,
        threadHandle: String?
    ) async throws {
        let cadence = HyphenFlowCadence(
            cadence: """
            import NonFungibleToken from \(nonFungibleTokenAddress)
            import MetadataViews from \(nonFungibleTokenAddress)
            import SwirlMoment from \(swirlContractAddress)
            import SwirlNametag from \(swirlContractAddress)

            /// Sets up collections of SwirlMoment, SwirlNametag for an account so it can receive these NFTs,
            /// and mints a SwirlNametag which acts as the account's profile.
            ///
            transaction(
                nickname: String,
                profileImage: String,
                keywords: [String],
                color: String,
                twitterHandle: String?,
                telegramHandle: String?,
                discordHandle: String?,
                threadHandle: String?
            ) {
                let collectionRef: &{NonFungibleToken.CollectionPublic}
                let profile: SwirlNametag.Profile

                prepare(signer: AuthAccount) {
                    if signer.borrow<&SwirlMoment.Collection>(from: SwirlMoment.CollectionStoragePath) == nil {
                        // set up SwirlMoment.Collection to the account.
                        signer.save(<-SwirlMoment.createEmptyCollection(), to: SwirlMoment.CollectionStoragePath)
                        signer.link<&{NonFungibleToken.CollectionPublic, SwirlMoment.SwirlMomentCollectionPublic, MetadataViews.ResolverCollection}>(
                            SwirlMoment.CollectionPublicPath,
                            target: SwirlMoment.CollectionStoragePath
                        )
                    }

                    if signer.borrow<&SwirlNametag.Collection>(from: SwirlNametag.CollectionStoragePath) == nil {
                        // set up SwirlNametag.Collection to the account.
                        signer.save(<-SwirlNametag.createEmptyCollection(), to: SwirlNametag.CollectionStoragePath)
                        signer.link<&{NonFungibleToken.CollectionPublic, SwirlNametag.SwirlNametagCollectionPublic, MetadataViews.ResolverCollection}>(
                            SwirlNametag.CollectionPublicPath,
                            target: SwirlNametag.CollectionStoragePath
                        )
                    }

                    self.collectionRef = signer.borrow<&{NonFungibleToken.CollectionPublic}>(from: SwirlNametag.CollectionStoragePath)
                        ?? panic("Could not borrow a reference to the SwirlNametag collection")

                    let socialHandles: [SwirlNametag.SocialHandle] = []
                    if twitterHandle != nil {
                        socialHandles.append(SwirlNametag.SocialHandle(
                            type: "twitter",
                            value: twitterHandle!
                        ))
                    }
                    if telegramHandle != nil {
                        socialHandles.append(SwirlNametag.SocialHandle(
                            type: "telegram",
                            value: telegramHandle!
                        ))
                    }
                    if discordHandle != nil {
                        socialHandles.append(SwirlNametag.SocialHandle(
                            type: "discord",
                            value: discordHandle!
                        ))
                    }
                    if threadHandle != nil {
                        socialHandles.append(SwirlNametag.SocialHandle(
                            type: "thread",
                            value: threadHandle!
                        ))
                    }

                    self.profile = SwirlNametag.Profile(
                        nickname: nickname,
                        profileImage: profileImage,
                        keywords: keywords,
                        color: color,
                        socialHandles: socialHandles
                    )
                }

                execute {
                    SwirlNametag.mintNFT(recipient: self.collectionRef, profile: self.profile)
                }
            }

            """
        )

        let signedTx = try await HyphenFlow.shared.makeSignedTransactionPayloadWithArguments(
            hyphenFlowCadence: cadence,
            args: [
                .string(nickname),
                .string(profileImage),
                .array(keywords.map { .string($0) }),
                .string("#\(color)"),
                .optional(.string(twitterHandle ?? "")),
                .optional(.string(telegramHandle ?? "")),
                .optional(.string(discordHandle ?? "")),
                .optional(.string(threadHandle ?? "")),
            ]
        )
        let txWait = try await flow.sendTransaction(transaction: signedTx)
        let txResult = try await txWait.onceSealed()

        print(txResult.blockId)
        print("==== [SwirlBlockchainManager] create namecard transaction complete. Transaction hash -> \(txWait)")

        _ = try await getMyNameCard()
    }

    func updateMyNameCard(
        nickname: String,
        profileImage: String,
        keywords: [String],
        color: String,
        twitterHandle: String?,
        telegramHandle: String?,
        discordHandle: String?,
        threadHandle: String?
    ) async throws {
        let cadence = HyphenFlowCadence(
            cadence: """
            import SwirlNametag from \(swirlContractAddress)

            /// Updates existing nametag.
            transaction(
                nickname: String,
                profileImage: String,
                keywords: [String],
                color: String,
                twitterHandle: String?,
                telegramHandle: String?,
                discordHandle: String?,
                threadHandle: String?
            ) {
                let collection: &SwirlNametag.Collection
                let newProfile: SwirlNametag.Profile

                prepare(signer: AuthAccount) {
                    self.collection = signer.borrow<&SwirlNametag.Collection>(from: SwirlNametag.CollectionStoragePath)
                        ?? panic("Could not borrow a reference to the SwirlNametag collection")

                    if self.collection.getIDs().length == 0 {
                        panic("No nametags exist in the collection")
                    }

                    let socialHandles: [SwirlNametag.SocialHandle] = []
                    if twitterHandle != nil {
                        socialHandles.append(SwirlNametag.SocialHandle(
                            type: "twitter",
                            value: twitterHandle!
                        ))
                    }
                    if telegramHandle != nil {
                        socialHandles.append(SwirlNametag.SocialHandle(
                            type: "telegram",
                            value: telegramHandle!
                        ))
                    }
                    if discordHandle != nil {
                        socialHandles.append(SwirlNametag.SocialHandle(
                            type: "discord",
                            value: discordHandle!
                        ))
                    }
                    if threadHandle != nil {
                        socialHandles.append(SwirlNametag.SocialHandle(
                            type: "thread",
                            value: threadHandle!
                        ))
                    }

                    self.newProfile = SwirlNametag.Profile(
                        nickname: nickname,
                        profileImage: profileImage,
                        keywords: keywords,
                        color: color,
                        socialHandles: socialHandles
                    )
                }

                execute {
                    self.collection.updateSwirlNametag(profile: self.newProfile)
                }
            }
            """
        )

        let signedTx = try await HyphenFlow.shared.makeSignedTransactionPayloadWithArguments(
            hyphenFlowCadence: cadence,
            args: [
                .string(nickname),
                .string(profileImage),
                .array(keywords.map { .string($0) }),
                .string(color),
                .optional(.string(twitterHandle ?? "")),
                .optional(.string(telegramHandle ?? "")),
                .optional(.string(discordHandle ?? "")),
                .optional(.string(threadHandle ?? "")),
            ]
        )
        let txWait = try await flow.sendTransaction(transaction: signedTx)
        print(txWait)
        let txResult = try await txWait.onceSealed()
        myNameCard = nil
    }

    func evalProfOfMeetingSignData(lat: Float, lng: Float) async throws -> String {
        let script = Flow.Script(text: """
        import SwirlMoment from \(swirlContractAddress)

        /// Evaluate signature message (JSON payload) of Proof-of-Meeting.
        /// Of course it can be constructed on off-chain, but using this query is recommended because
        /// the payload might change in the future.
        pub fun main(address: Address, keyIndex: Int, lat: Fix64, lng: Fix64): String {
            let pol = SwirlMoment.ProofOfMeeting(
                address: getAccount(address),
                location: SwirlMoment.Coordinate(lat: lat, lng: lng),
                nonce: SwirlMoment.nextNonceForProofOfMeeting,
                keyIndex: keyIndex,
                signature: "<unused-not-yet>" // we don't validate here, so it's ok to put dummy
            )
            return String.fromUTF8(pol.signedData())!
        }
        """)

        let result = try await flow.executeScriptAtLatestBlock(
            script: script,
            arguments: [
                .address(flowAccount!.address),
                .int(1),
                .fix64(Decimal(string: lat.description)!),
                .fix64(Decimal(string: lng.description)!),
            ]
        )

        let decodeResult: String = try result.decode()
        return decodeResult
    }

    func mintMoment(
        payload: [SwirlMomentSignaturePayload]
    ) async throws {
        let cadence = HyphenFlowCadence(
            cadence: """
            import NonFungibleToken from \(nonFungibleTokenAddress)
            import MetadataViews from \(nonFungibleTokenAddress)
            import SwirlMoment from \(swirlContractAddress)

            transaction(address: [Address], lat: [Fix64], lng: [Fix64], nonce: [UInt64], keyIndex: [Int], signature: [String]) {
                let proofs: [SwirlMoment.ProofOfMeeting]

                prepare(signer: AuthAccount) {
                    self.proofs = []

                    for i, addr in address {
                        let proof = SwirlMoment.ProofOfMeeting(
                            account: getAccount(addr),
                            location: SwirlMoment.Coordinate(lat[i], lng[i]),
                            nonce: nonce[i],
                            keyIndex: keyIndex[i],
                            signature: signature[i]
                        )
                        self.proofs.append(proof)
                    }
                }

                execute {
                    SwirlMoment.mint(proofs: self.proofs)
                }
            }

            """
        )

        let signedTx = try await HyphenFlow.shared.makeSignedTransactionPayloadWithArguments(
            hyphenFlowCadence: cadence,
            args: [
                .array(payload.map { .address(Flow.Address(hex: $0.address)) }),
                .array(payload.map { .fix64(Decimal(string: $0.lat.description)!) }),
                .array(payload.map { .fix64(Decimal(string: $0.lng.description)!) }),
                .array(payload.map { .uint64(UInt64(Int64($0.nonce))) }),
                .array(payload.map { _ in .int(1) }),
                .array(payload.map { .string($0.signature) }),
            ]
        )
        let txWait = try await flow.sendTransaction(transaction: signedTx)
        let txResult = try await txWait.onceSealed()

        print("==== [SwirlBlockchainManager] mint moment successfully. Transaction hash -> \(txWait)")
    }

    func burnMoment(with id: UInt64) async throws {
        let cadence = HyphenFlowCadence(
            cadence: """
            import NonFungibleToken from \(nonFungibleTokenAddress)
            import SwirlMoment from \(swirlContractAddress)

            transaction(id: UInt64) {
                /// Reference that will be used for the owner's collection
                let collectionRef: &SwirlMoment.Collection

                prepare(signer: AuthAccount) {
                    // borrow a reference to the owner's collection
                    self.collectionRef = signer.borrow<&SwirlMoment.Collection>(from: SwirlMoment.CollectionStoragePath)
                        ?? panic("Account does not store an object at the specified path")

                }

                execute {
                    self.collectionRef.burn(id: id)
                }
            }
            """
        )

        let signedTx = try await HyphenFlow.shared.makeSignedTransactionPayloadWithArguments(
            hyphenFlowCadence: cadence,
            args: [
                .uint64(id),
            ]
        )
        let txWait = try await flow.sendTransaction(transaction: signedTx)
        let txResult = try await txWait.onceSealed()

        print("==== [SwirlBlockchainManager] burn moment successfully. Transaction hash -> \(txWait)")
    }
}

//        try await updateMyNameCard(
//            nickname: "Doooooooora",
//            profileImage: "https://storage.googleapis.com/nftimagebucket/tokens/0x598585fe8724d7ea3f527ddf712c2faa205dabe7/preview/1875.png",
//            keywords: ["dora", "developer", "doraemon"],
//            color: "#61BDFF",
//            twitterHandle: "own_midnight_twt",
//            telegramHandle: "oooooooom",
//            discordHandle: nil,
//            threadHandle: "own_ttttt"
//        )
