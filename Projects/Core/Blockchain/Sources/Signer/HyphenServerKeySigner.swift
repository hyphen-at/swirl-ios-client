import CryptoKit
import Flow
import Foundation
import HyphenNetwork

final class HyphenServerKeySigner: FlowSigner {
    var address: Flow.Address {
        SwirlBlockchainManager.shared.flowAccount!.address
    }

    private var _keyIndex: Int = 0
    var keyIndex: Int {
        _keyIndex
    }

    func sign(transaction _: Flow.Transaction, signableData: Data) async throws -> Data {
        print("===== [HyphenSigner] HyphenServerKey signing request")

        let signResult = try await HyphenNetworking.shared.signTransactionWithServerKey(message: signableData.hexValue)
        return Data(hexString: signResult.signature.signature)!
    }
}
