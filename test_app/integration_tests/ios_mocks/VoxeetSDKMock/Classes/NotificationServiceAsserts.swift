import Foundation

public class NotificationServiceAsserts {

    private static var instance: NotificationServiceAsserts?
    public static func create() {
        instance = .init()
    }

    var methodChannel: AssertsMethodChannel?

    public init() {
        assertsMethodChannelFactory.createAssertMethodChannel(
            forSdkAsserts: self,
            channelName: "IntegrationTesting.NotificationServiceAsserts"
        )
    }

    private func assertSubscribeArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.notification.declineHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun, hasRun)
        }

        let mockArgs = VoxeetSDK.shared.notification.declineArgs
        try ifKeyExists(arg: args, key: "conference") { args in
            try ConferenceServiceAssertUtils.assertConference(
                args: args, mockConference: mockArgs
            )
        }
    }

    private func assertUnsubscribeArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.notification.declineHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun, hasRun)
        }

        let mockArgs = VoxeetSDK.shared.notification.declineArgs
        try ifKeyExists(arg: args, key: "conference") { args in
            try ConferenceServiceAssertUtils.assertConference(
                args: args, mockConference: mockArgs
            )
        }
    }

    private func assertInviteArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.notification.inviteHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun, hasRun)
        }

        let mockArgs = VoxeetSDK.shared.notification.inviteArgs
        try ifKeyExists(arg: args, key: "conference") { conference in
            try ConferenceServiceAssertUtils.assertConference(
                args: conference, mockConference: mockArgs?.conference
            )
        }

        let mockParticipantInvited = mockArgs?.participantsInvited.first
        try ifKeyExists(arg: args, key: "participantInvited") { (participantInvited: [String:Any]) in
            try ifKeyExists(arg: participantInvited, key: "name") { name in
                try nativeAssertEquals(mockParticipantInvited?.info.name, name)
            }
            try ifKeyExists(arg: participantInvited, key: "avatarUrl") { avatarUrl in
                try nativeAssertEquals(mockParticipantInvited?.info.avatarURL, avatarUrl)
            }
            try ifKeyExists(arg: participantInvited, key: "externalId") { externalId in
                try nativeAssertEquals(mockParticipantInvited?.info.externalID, externalId)
            }
            try ifKeyExists(arg: participantInvited, key: "permission") { permission in
                try nativeAssertEquals(mockParticipantInvited?.permissions?.first?.rawValue, permission)
            }
        }
    }

    private func assertDeclineArgs(args: [String: Any]) throws {
        let mockHasRun = VoxeetSDK.shared.notification.declineHasRun
        try ifKeyExists(arg: args, key: "hasRun") { (hasRun: Bool) in
            try nativeAssertEquals(mockHasRun, hasRun)
        }

        let mockArgs = VoxeetSDK.shared.notification.declineArgs
        try ifKeyExists(arg: args, key: "conference") { args in
            try ConferenceServiceAssertUtils.assertConference(
                args: args, mockConference: mockArgs
            )
        }
    }
}

extension NotificationServiceAsserts: SDKAsserts {

    public func runAssert(_ assert: String, args: [String: Any], result: (SDKAssertResult) -> Void) {
        do {
            switch assert {

            case "assertSubscribeArgs":
                try assertSubscribeArgs(args: args)

            case "assertUnsubscribeArgs":
                try assertUnsubscribeArgs(args: args)

            case "assertInviteArgs":
                try assertInviteArgs(args: args)

            case "assertDeclineArgs":
                try assertDeclineArgs(args: args)

            default:
                throw SDKAssertError.unknownAssert
            }
            result(.success(()))
        } catch {
            result(SDKAssertError.toResult(error: error))
        }
    }
}

