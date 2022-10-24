import Foundation
import VoxeetSDK


class SdkBinding: Binding {

    // MARK: - Methods
    /// Initializes the SDK using the customer key and secret.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func initialize(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            VoxeetSDK.shared.initialize(
                consumerKey: try flutterArguments.asDictionary(argKey: "customerKey").decode(),
                consumerSecret: try flutterArguments.asDictionary(argKey: "customerSecret").decode()
            )
            completionHandler.success()
        } catch {
            completionHandler.failure(error)
        }
    }

    // MARK: - Methods
    /// Initializes the SDK and invokes the SDK with a third-party authentication feature.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func initializeWithToken(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            VoxeetSDK.shared.initialize(
                accessToken: try flutterArguments.asDictionary(argKey: "accessToken").decode(),
                refreshTokenClosureWithParam: { [weak self] closure, _ in
                    DispatchQueue.main.async {
                        self?.channel.invokeMethod("getRefreshToken", arguments: nil, result: { result -> Void in
                            do {
                                guard let token = result as? String else {
                                    throw BindingError.noRefreshTokenProvided
                                }
                                closure(token)
                            } catch {
                                closure(nil)
                                // TODO: we need to find a better way dealing with the reporting the error.
                            }
                        })
                    }
                }
            )
            completionHandler.success()
        } catch {
            completionHandler.failure(error)
        }
    }
}

extension SdkBinding: FlutterBinding {
    func handle(
        methodName: String,
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        switch methodName {
        case "initialize":
            initialize(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "initializeToken":
            initializeWithToken(flutterArguments: flutterArguments, completionHandler: completionHandler)
        default:
            completionHandler.methodNotImplemented()
        }
    }
}
