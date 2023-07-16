import Flow
import Foundation
import HyphenCore

final class SwirlBlockchainManager: NSObject {
    static let shared: SwirlBlockchainManager = .init()

    private var flowAccount: Flow.Account? = nil

    override private init() {
        flow.configure(chainID: .testnet)
    }

    func loadAccount() async throws {
        print("===== [SwirlBlockchainManager] loading account...")

        let account = try await flow.getAccountAtLatestBlock(address: Flow.Address(hex: Hyphen.shared.getWalletAddress()!))
        flowAccount = account

        print(flowAccount!)

        try await createMyNameCard()
    }

    func createMyNameCard() async throws {
        let deviceKeySigner = HyphenDeviceKeySigner()
        let serverKeySigner = HyphenServerKeySigner()
        let payMasterKeySigner = HyphenPayMasterKeySigner()

        let signers: [FlowSigner] = [serverKeySigner, deviceKeySigner, payMasterKeySigner]

        var unsignedTx = try! await flow.buildTransaction {
            cadence {
                """
                import NonFungibleToken from 0x631e88ae7f1d7c20
                import MetadataViews from 0x631e88ae7f1d7c20
                import SwirlMoment from 0xfe9604dcbf6b270e
                import SwirlNametag from 0xfe9604dcbf6b270e

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
                                type: "twitter",
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
            }

            proposer {
                Flow.TransactionProposalKey(address: deviceKeySigner.address, keyIndex: 1)
            }

            arguments {
                [
                    .string("Doooooooora"),
                    .string("https://storage.googleapis.com/nftimagebucket/tokens/0x598585fe8724d7ea3f527ddf712c2faa205dabe7/preview/1875.png"),
                    .array([.string("dora"), .string("developer")]),
                    .string("#ec137f"),
                    .optional(.string("")),
                    .optional(.string("")),
                    .optional(.string("owl_midnight")),
                    .optional(.string("")),
                ]
            }

            payer {
                payMasterKeySigner.address
            }

            authorizers {
                deviceKeySigner.address
            }
        }

        let signedTx = try await unsignedTx.sign(signers: signers)
        let result = try await flow.sendTransaction(transaction: signedTx)

        print(result)
    }
}
