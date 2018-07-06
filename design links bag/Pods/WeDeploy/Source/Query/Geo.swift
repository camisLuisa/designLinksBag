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

public protocol Geo {
	var value: Any { get }
}

public struct GeoPoint: Geo {
	public let lat: Double
	public let long: Double

	public init(lat: Double, long: Double) {
		self.lat = lat
		self.long = long
	}

	public var value: Any {
		return "\(lat),\(long)"
	}
}

public struct BoundingBox: Geo {
	public let upperLeft: GeoPoint
	public let lowerRight: GeoPoint

	public init(upperLeft: GeoPoint, lowerRight: GeoPoint) {
		self.upperLeft = upperLeft
		self.lowerRight = lowerRight
	}

	public var value: Any {
		var val = [String: Any]()
		val["type"] = "envelope"
		val["coordinates"] = [upperLeft.value, lowerRight.value]

		return val
	}
}

public struct Circle: Geo {
	public let center: GeoPoint
	public let radius: Double

	public init(center: GeoPoint, radius: Double) {
		self.center = center
		self.radius = radius
	}

	public var value: Any {
		var val = [String: Any]()
		val["type"] = "circle"
		val["coordinates"] = center.value
		val["radius"] = radius

		return val
	}
}

public struct Line: Geo {
	public let coordinates: [GeoPoint]

	public init(coordinates: [GeoPoint]) {
		self.coordinates = coordinates
	}

	public var value: Any {
		var val = [String: Any]()
		val["type"] = "linestring"
		val["coordinates"] = coordinates.map({ $0.value })

		return val
	}
}

public struct Polygon: Geo {
	public let coordinates: [GeoPoint]

	public init(coordinates: [GeoPoint]) {
		self.coordinates = coordinates
	}

	public var value: Any {
		var val = [String: Any]()
		val["type"] = "polygon"
		val["coordinates"] = coordinates.map({ $0.value })

		return val
	}
}
