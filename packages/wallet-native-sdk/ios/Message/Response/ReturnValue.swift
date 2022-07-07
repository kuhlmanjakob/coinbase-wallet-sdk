//
//  ReturnValue.swift
//  WalletSegue
//
//  Created by Jungho Bang on 6/24/22.
//

import Foundation

public typealias ReturnValue = Result<String, Error>

extension String: BaseContent {}
extension Result: BaseContent where Success: BaseContent {}

@available(iOS 13.0, *)
public typealias ResponseResult = Result<BaseMessage<[ReturnValue]>, Error>

@available(iOS 13.0, *)
public typealias ResponseHandler = (ResponseResult) -> Void

@available(iOS 13.0, *)
extension ResponseContent.Value {
    var returnValue: ReturnValue {
        switch self {
        case let .result(value):
            return .success(value)
        case let .error(code, message):
            return .failure(CoinbaseWalletSDK.Error.walletExecutionFailed(code, message))
        }
    }
}

@available(iOS 13.0, *)
extension ResponseMessage {
    var result: ResponseResult {
        switch self.content {
        case .response(_, let values):
            let result = BaseMessage<[ReturnValue]>.copy(
                self,
                replaceContentWith: values.map({ $0.returnValue })
            )
            return .success(result)
        case .failure(_, let description):
            return .failure(CoinbaseWalletSDK.Error.walletReturnedError(description))
        }
    }
}
