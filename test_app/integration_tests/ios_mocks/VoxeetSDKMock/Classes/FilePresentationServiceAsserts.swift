import Foundation

public class FilePresentationServiceAsserts {
    
    private static var instance: FilePresentationServiceAsserts?
    public static func create() {
        instance = .init()
    }
    
    var methodChannel: AssertsMethodChannel?
    
    public init() {
        assertsMethodChannelFactory.createAssertMethodChannel(
            forSdkAsserts: self,
            channelName: "IntegrationTesting.FilePresentationServiceAsserts"
        )
    }
    
    private func assertGetCurrentArgs(args: [String: Any]) throws {
        let mockArgs = VoxeetSDK.shared.filePresentation.current
        try ifKeyExists(arg: args, key: "id") { (id: String) in
            try nativeAssertEquals(mockArgs?.id, id)
        }
        
        try ifKeyExists(arg: args, key: "ownerId") { (ownerId: String) in
            try nativeAssertEquals(mockArgs?.owner.id, ownerId)
        }
        
        try ifKeyExists(arg: args, key: "imageCount") { (imageCount: Int) in
            try nativeAssertEquals(mockArgs?.imageCount, imageCount)
        }
        
        try ifKeyExists(arg: args, key: "position") { (position: Int) in
            try nativeAssertEquals(mockArgs?.position, position)
        }
    }
    
    private func assertConvertArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.filePresentation.convertHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun, hasRun)
        }
        
        let mockArgs = VoxeetSDK.shared.filePresentation.convertArgs
        try ifKeyExists(arg: args, key: "uri") { (uri: String) in
            try nativeAssertEquals(mockArgs?.path.absoluteString, uri)
        }
    }
    
    private func assertSetPageArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.filePresentation.updateHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun, hasRun)
        }
        
        let mockArgs = VoxeetSDK.shared.filePresentation.updateArgs
        try ifKeyExists(arg: args, key: "page") { (page: Int) in
            try nativeAssertEquals(mockArgs, page)
        }
    }
    
    private func assertStartArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.filePresentation.startHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun, hasRun)
        }
        
        let mockArgs = VoxeetSDK.shared.filePresentation.startArgs
        try ifKeyExists(arg: args, key: "id") { (id: String) in
            try nativeAssertEquals(mockArgs?.id, id)
        }
        
        try ifKeyExists(arg: args, key: "imageCount") { (imageCount: Int) in
            try nativeAssertEquals(mockArgs?.imageCount, imageCount)
        }
    }
    
    private func assertStopArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.filePresentation.stopHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun, hasRun)
        }
    }
    
    private func setGetImageReturn(args: [String: Any]) throws {
        try ifKeyExists(arg: args, key: "url", closure: { (url: String) in
            VoxeetSDK.shared.filePresentation.imageReturn = URL(string: url)
        })
    }
    
    private func assertGetImageArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.filePresentation.imageHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun, hasRun)
        }
        
        let mockArgs = VoxeetSDK.shared.filePresentation.imageArgs
        try ifKeyExists(arg: args, key: "page") { (page: Int) in
            try nativeAssertEquals(mockArgs, page)
        }
    }
    
    private func setGetThumbnailReturn(args: [String: Any]) throws {
        try ifKeyExists(arg: args, key: "url", closure: { (url: String) in
            VoxeetSDK.shared.filePresentation.thumbnailReturn = URL(string: url)
        })
    }
    
    private func assertGetThumbnailArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.filePresentation.thumbnailHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun, hasRun)
        }
        
        let mockArgs = VoxeetSDK.shared.filePresentation.thumbnailArgs
        try ifKeyExists(arg: args, key: "page") { (page: Int) in
            try nativeAssertEquals(mockArgs, page)
        }
    }
}

extension FilePresentationServiceAsserts: SDKAsserts {
    
    public func runAssert(_ assert: String, args: [String: Any], result: (SDKAssertResult) -> Void) {
        do {
            switch assert {
                
            case "assertGetCurrentArgs":
                try assertGetCurrentArgs(args: args)
                
            case "assertConvertArgs":
                try assertConvertArgs(args: args)
                
            case "assertSetPageArgs":
                try assertSetPageArgs(args: args)
                
            case "assertStartArgs":
                try assertStartArgs(args: args)
                
            case "assertStopArgs":
                try assertStopArgs(args: args)
                
            case "setGetImageReturn":
                try setGetImageReturn(args: args)
                
            case "assertGetImageArgs":
                try assertGetImageArgs(args: args)
                
            case "setGetThumbnailReturn":
                try setGetThumbnailReturn(args: args)
                
            case "assertGetThumbnailArgs":
                try assertGetThumbnailArgs(args: args)
                
            default:
                throw SDKAssertError.unknownAssert
            }
            result(.success(()))
        } catch {
            result(SDKAssertError.toResult(error: error))
        }
    }
}

