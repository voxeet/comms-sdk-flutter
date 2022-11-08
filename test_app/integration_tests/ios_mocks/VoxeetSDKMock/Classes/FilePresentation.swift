import Foundation

@objcMembers public class VTFilePresentation: NSObject {
	public internal(set) var id: String
	public internal(set) var owner: VTParticipant
	public internal(set) var imageCount: Int
	public internal(set) var position: Int

	internal init(id: String, owner: VTParticipant, imageCount: Int, position: Int) {
		self.id = id
		self.owner = owner
		self.imageCount = imageCount
		self.position = position
	}
}

@objcMembers public class VTFileConverted: NSObject {
	public internal(set) var id: String
	public internal(set) var imageCount: Int
	public internal(set) var ownerID: String?
	public internal(set) var name: String?
	public internal(set) var size: NSNumber?

	public init(id: String, imageCount: Int) {
		self.id = id
		self.imageCount = imageCount
	}

	internal init(id: String, ownerID: String, name: String, imageCount: Int, size: Int) {
		self.id = id
		self.imageCount = imageCount
		self.ownerID = ownerID
		self.name = name
		self.size = NSNumber(value: size)
	}
}
