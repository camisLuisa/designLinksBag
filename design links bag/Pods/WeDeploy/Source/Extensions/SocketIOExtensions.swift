/**
* Copyright (c) 2000-present Liferay, Inc. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
* 1. Redistributions of source code must retain the above copyright notice,
* this list of conditions and the following disclaimer.
*
* 2. Redistributions in binary form must reproduce the above copyright notice,
* this list of conditions and the following disclaimer in the documentation
* and/or other materials provided with the distribution.
*
* 3. Neither the name of Liferay, Inc. nor the names of its contributors may
* be used to endorse or promote products derived from this software without
* specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
* POSSIBILITY OF SUCH DAMAGE.
*/

import Foundation
import RxSwift
import SocketIO

public enum RealTimeEventType: String {
	case changes
	case error
	case create
	case update
	case delete

	public static func realTimeEvent(from type: String, eventItems: [Any]) -> RealTimeEvent? {
		guard let eventType = RealTimeEventType(rawValue: type) else { return nil }

		return realTimeEvent(from: eventType, eventItems: eventItems)
	}

	public static func realTimeEvent(from type: RealTimeEventType, eventItems: [Any]) -> RealTimeEvent {
		let document: [String: Any]
		switch type {
		case .create, .update, .delete:
			let rawEvent = eventItems[0] as! [String: Any]
			document = rawEvent["document"] as! [String: Any]

		case .changes:
			let rawEvent = eventItems[0] as? [[String: Any]]
			document = ["changes": rawEvent as Any]

		case .error:
			let error = eventItems[0]
			document = ["error": error]
		}

		return RealTimeEvent(type: type, document: document)
	}
}

public struct RealTimeEvent {
	public let type: RealTimeEventType
	public let document: [String: Any]

	public init(type: RealTimeEventType, document: [String: Any]) {
		self.type = type
		self.document = document
	}
}

public extension SocketIOClient {

	func on(_ event: String) -> Observable<RealTimeEvent> {
		var selfRetained: SocketIOClient? = self

		return Observable.create { [weak self] observer in
			self?.on(event) { items, _ in
				guard let realTimeEvent = RealTimeEventType.realTimeEvent(from: event, eventItems: items) else {
					return
				}

				observer.on(.next(realTimeEvent))
			}

			return Disposables.create(with: {
				selfRetained?.removeAllHandlers()
				selfRetained = nil
			})
		}
	}

	func on(_ events: [RealTimeEventType], callback: @escaping (RealTimeEvent) -> Void) {
		events.forEach { on($0, callback: callback)}
	}

	func on(_ event: RealTimeEventType, callback: @escaping (RealTimeEvent) -> Void) {
		self.on(event.rawValue) { items, _ in
			let realTimeEvent = RealTimeEventType.realTimeEvent(from: event, eventItems: items)

			callback(realTimeEvent)
		}
	}

	func on(_ event: RealTimeEventType) -> Observable<RealTimeEvent> {
		return on(event.rawValue)
	}

	func on(_ events: [RealTimeEventType]) -> Observable<RealTimeEvent> {
		let realTimeEventsObservables = events.map { on($0) }

		return Observable.from(realTimeEventsObservables).merge()
	}

}
