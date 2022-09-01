import Foundation
import VoxeetSDK

extension DTO {

    struct File: Codable {
        let uri: String?
    }

    struct FilePresentation: Codable {
        let id: String?
        let owner: Participant?
        let imageCount: Int?
        let position: Int?

        init(filePresentation: VTFilePresentation) {
            id = filePresentation.id
            owner = Participant.init(participant: filePresentation.owner)
            imageCount = filePresentation.imageCount
            position = filePresentation.position
        }
    }

    struct FileConverted: Codable {
        let id: String?
        let imageCount: Int?
        let ownerID: String?
        let name: String?
        let size: Int?

        init(fileConverted: VTFileConverted) {
            id = fileConverted.id
            imageCount = fileConverted.imageCount
            ownerID = fileConverted.ownerID
            name = fileConverted.name
            size = fileConverted.size?.intValue
        }

        func toSdkType() -> VTFileConverted {
            return .init(
                id: id ?? "",
                imageCount: imageCount ?? 0
            )
        }
    }
}
