import Flow
import Foundation
@_spi(HyphenInternal) import HyphenCore

final class HyphenDeviceKeySigner: FlowSigner {
    var address: Flow.Address {
        Flow.Address(hex: SwirlBlockchainManager.shared.getCachedAccountAddress())
    }

    var keyIndex: Int {
        1
    }

    func sign(transaction _: Flow.Transaction, signableData: Data) async throws -> Data {
        print("===== [HyphenSigner] HyphenDeviceKey signing request")
        return HyphenCryptography.signData(signableData)!
    }
}
