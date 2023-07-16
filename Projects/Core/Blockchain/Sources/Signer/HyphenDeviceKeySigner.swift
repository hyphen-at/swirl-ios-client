import Flow
import Foundation
@_spi(HyphenInternal) import HyphenCore

final class HyphenDeviceKeySigner: FlowSigner {
    var address: Flow.Address {
        Flow.Address(hex: Hyphen.shared.getWalletAddress()!)
    }

    var keyIndex: Int {
        1
    }

    func sign(transaction _: Flow.Transaction, signableData: Data) async throws -> Data {
        HyphenCryptography.signData(signableData)!
    }
}
