import Foundation
import VoxeetSDK

// MARK: - Supported Events
private enum EventKeys: String, CaseIterable {
    /// Emitted when the file is converted.
    case fileConverted = "EVENT_FILEPRESENTATION_FILE_CONVERTED"
    /// Emitted when the presenter started the file presentation.
    case filePresentationStarted = "EVENT_FILEPRESENTATION_STARTED"
    /// Emitted when the presenter ended the file presentation.
    case filePresentationStopped = "EVENT_FILEPRESENTATION_STOPPED"
    /// Emitted when the presenter changed the displayed page of the shared file.
    case filePresentationUpdated = "EVENT_FILEPRESENTATION_UPDATED"
}

class FilePresentationServiceBinding: Binding {
    
    /// Returns information about the current state of the file presentation.
    /// - Parameters:
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func getCurrent(
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        guard let current = VoxeetSDK.shared.filePresentation.current else {
            completionHandler.success()
            return
        }
        completionHandler.success(encodable: DTO.FilePresentation(filePresentation: current))
    }
    
    /// Converts a provided file into multiple images.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func convert(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            guard let uri: String = try (flutterArguments.asSingle().decode(type: DTO.File.self).uri),
                  var urlComponents = URLComponents(string: uri)
            else {
                throw BindingError.noUrlProvided
            }
            
            if urlComponents.scheme == nil {
                urlComponents.scheme = "file"
            }
            guard let url = urlComponents.url else {
                throw BindingError.noUrlProvided
            }
            
            VoxeetSDK.shared.filePresentation.convert(
                path: url,
                progress: nil,
                success: { fileConverted in
                    completionHandler.success(encodable: DTO.FileConverted(fileConverted: fileConverted))
                }, fail: { error in
                    completionHandler.handleError(error)?.orSuccess()
                }
            )
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Informs the service to send the updated page number to conference participants.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func setPage(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let page: Int = try flutterArguments.asDictionary(argKey: "page").decode() ?? 0
            
            VoxeetSDK.shared.filePresentation.update(page: page) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Starts presenting a converted file.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func start(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let fileConverted = try flutterArguments.asSingle().decode(type: DTO.FileConverted.self)
            VoxeetSDK.shared.filePresentation.start(fileConverted: fileConverted.toSdkType()) { error in
                completionHandler.handleError(error)?.orSuccess()
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    /// Stops a file presentation.
    /// - Parameters:
    ///   - flutterArguments: Method arguments passed from Flutter.
    ///   - completionHandler: Call methods on this instance when execution has finished.
    func stop(
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        VoxeetSDK.shared.filePresentation.stop() { error in
            completionHandler.handleError(error)?.orSuccess()
        }
    }
    
    func getImage(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let page: Int = try flutterArguments.asDictionary(argKey: "page").decode() ?? 0
            if let urlString = VoxeetSDK.shared.filePresentation.image(page: page)?.absoluteString {
                completionHandler.success(flutterConvertible: urlString)
            }
        } catch {
            completionHandler.failure(error)
        }
    }
    
    func getThumbnail(
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        do {
            let page: Int = try flutterArguments.asDictionary(argKey: "page").decode() ?? 0
            if let urlString = VoxeetSDK.shared.filePresentation.thumbnail(page: page)?.absoluteString {
                completionHandler.success(flutterConvertible: urlString)
            }
        } catch {
            completionHandler.failure(error)
        }
    }
}

extension FilePresentationServiceBinding: FlutterBinding {
    func handle(
        methodName: String,
        flutterArguments: FlutterMethodCallArguments,
        completionHandler: FlutterMethodCallCompletionHandler
    ) {
        switch methodName {
        case "getCurrent":
            getCurrent(completionHandler: completionHandler)
        case "convert":
            convert(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "setPage":
            setPage(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "start":
            start(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "stop":
            stop(completionHandler: completionHandler)
        case "getImage":
            getImage(flutterArguments: flutterArguments, completionHandler: completionHandler)
        case "getThumbnail":
            getThumbnail(flutterArguments: flutterArguments, completionHandler: completionHandler)
        default:
            completionHandler.methodNotImplemented()
        }
    }
}

extension FilePresentationServiceBinding: VTFilePresentationDelegate {
    
    public func converted(fileConverted: VTFileConverted) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.fileConverted,
                body: DTO.FileConverted(fileConverted: fileConverted)
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func started(filePresentation: VTFilePresentation) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.filePresentationStarted,
                body: DTO.FilePresentation(filePresentation: filePresentation)
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func updated(filePresentation: VTFilePresentation) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.filePresentationUpdated,
                body: DTO.FilePresentation(filePresentation: filePresentation)
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func stopped(filePresentation: VTFilePresentation) {
        do {
            try nativeEventEmitter.sendEvent(
                event: EventKeys.filePresentationStopped,
                body: DTO.FilePresentation(filePresentation: filePresentation)
            )
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
}
