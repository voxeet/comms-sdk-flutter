import Foundation
import WebRTC

@objcMembers public class FilePresentationService: NSObject {

	public internal(set) var current: VTFilePresentation?
	public weak var delegate: VTFilePresentationDelegate?

	var convertHasRun: Bool = false
	var convertArgs: (path: URL, progress: ((_ progress: Double) -> Void)?)?
	var convertReturn: VTFileConverted = VTFileConverted(id: "", imageCount: 0)
	public func convert(path: URL, progress: ((_ progress: Double) -> Void)? = nil, success: ((_ fileConverted: VTFileConverted) -> Void)?, fail: ((_ error: NSError) -> Void)?){
		convertHasRun = true
		convertArgs = (path, progress)
		success?(convertReturn)
	}

	var imageHasRun: Bool = false
	var imageArgs: Int?
	var imageReturn: URL?
	public func image(page: Int) -> URL? {
		imageHasRun = true
		imageArgs = page
		return imageReturn
	}

	var thumbnailHasRun: Bool = false
	var thumbnailArgs: Int?
	var thumbnailReturn: URL?
	public func thumbnail(page: Int) -> URL? {
		thumbnailHasRun = true
		thumbnailArgs = page
		return thumbnailReturn
	}

	var updateHasRun: Bool = false
	var updateArgs: Int?
	var updateReturn: NSError?
	public func update(page: Int, completion: ((_ error: NSError?) -> Void)? = nil) {
		updateHasRun = true
		updateArgs = page
		completion?(updateReturn)
	}

	var startHasRun: Bool = false
	var startArgs: VTFileConverted?
	var startReturn: NSError?
	public func start(fileConverted: VTFileConverted, completion: ((_ error: NSError?) -> Void)? = nil) {
		startHasRun = true
		startArgs = fileConverted
		completion?(startReturn)
	}

	var stopHasRun: Bool = false
	var stopReturn: NSError?
	public func stop(completion: ((_ error: NSError?) -> Void)? = nil) {
		stopHasRun = true
		completion?(stopReturn)
	}
}

@objc public protocol VTFilePresentationDelegate {
	/// Emitted when a file is converted.
	@objc func converted(fileConverted: VTFileConverted)
	/// Emitted when a file presentation is started.
	@objc func started(filePresentation: VTFilePresentation)
	/// Emitted when a file presentation is updated.
	@objc func updated(filePresentation: VTFilePresentation)
	/// Emitted when a file presentation is stopped.
	@objc func stopped(filePresentation: VTFilePresentation)
}
