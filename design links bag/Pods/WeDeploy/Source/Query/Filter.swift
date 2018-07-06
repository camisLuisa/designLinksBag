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

public typealias ExtendedGraphemeClusterLiteralType = String
public typealias UnicodeScalarLiteralType = String

public class Filter: CustomStringConvertible, ExpressibleByStringLiteral {

	public private(set) var filter = [String: AnyObject]()

	public var description: String {
		return filter.asJSON
	}

	public convenience init(_ expression: String) {
		var parts = expression.split {
			$0 == " "
		}.map(String.init)

		let field = parts[0]
		let op = parts[1]

		if let i = Int(parts[2]) {
			self.init(field: field, op: op, value: i)
		}
		else {
			self.init(field: field, op: op, value: parts[2])
		}
	}

	public convenience init(_ field: String, _ value: Any) {
		self.init(field: field, op: "=", value: value)
	}

	public init(field: String, op: String, value: Any?) {
		var newFilter: [String: Any] = [
			"operator": op
		]

		if let value = value {
			newFilter["value"] = value
		}

		filter[field] = newFilter as AnyObject
	}

	public init() {}

	public required convenience init(extendedGraphemeClusterLiteral: String) {
		self.init(extendedGraphemeClusterLiteral)
	}

	public required convenience init(stringLiteral: StringLiteralType) {
		self.init(stringLiteral)
	}

	public required convenience init(unicodeScalarLiteral: String) {
		self.init(unicodeScalarLiteral)
	}

	public func and(filters: Filter...) -> Self {
		return self.and(filters)
	}

	public static func any(field: String, value: [Any]) -> Filter {
		return Filter(field: field, op: "any", value: value)
	}

	public static func equal(field: String, value: Any) -> Filter {
		return Filter(field, value)
	}

	public static func gt(field: String, value: Any) -> Filter {
		return Filter(field: field, op: ">", value: value)
	}

	public static func gte(field: String, value: Any) -> Filter {
		return Filter(field: field, op: ">=", value: value)
	}

	public static func lt(field: String, value: Any) -> Filter {
		return Filter(field: field, op: "<", value: value)
	}

	public static func lte(field: String, value: Any) -> Filter {
		return Filter(field: field, op: "<=", value: value)
	}

	public static func none(field: String, value: [Any]) -> Filter {
		return Filter(field: field, op: "none", value: value)
	}

	public func not() -> Filter {
		filter = [
			"not": filter as AnyObject
		]

		return self
	}

	public static func notEqual(field: String, value: Any) -> Filter {
		return Filter(field: field, op: "!=", value: value)
	}

	public func or(filters: Filter...) -> Self {
		return self.or(filters)
	}

	public static func regex(field: String, value: Any) -> Filter {
		return Filter(field: field, op: "~", value: value)
	}

	public static func match(field: String, pattern: Any) -> Filter {
		return Filter(field: field, op: "match", value: pattern)
	}

	public static func similar(field: String, query: Any) -> Filter {
		return Filter(field: field, op: "similar", value: ["query": query])
	}

	public static func distance(field: String, latitude: Double,
			longitude: Double, range: Range) -> Filter {

		var value: [String: Any] = [
			"location": [latitude, longitude]
		]

		if let min = range.from {
			value["min"] = min
		}
		if let max = range.to {
			value["max"] = max
		}

		return Filter(field: field, op: "gd", value: value)
	}

	public static func distance(field: String, latitude: Double,
			longitude: Double, distance: DistanceUnit) -> Filter {

		return Filter.distance(field: field, latitude: latitude,
			longitude: longitude, range: Range(to: distance.value))
	}

	public static func range(field: String, range: Range) -> Filter {
		return Filter(field: field, op: "range", value: range.value)
	}

	public static func polygon(field: String, points: [GeoPoint]) -> Filter {
		return Filter(field: field, op: "gp", value: points.map({ $0.value}))
	}

	public static func shape(field: String, shapes: [Geo]) -> Filter {
		let value = [
			"type": "geometrycollection",
			"geometries": shapes.map({ $0.value })
		] as [String: Any]

		return Filter(field: field, op: "gs", value: value)
	}

	public static func phrase(field: String, value: Any) -> Filter {
		return Filter(field: field, op: "phrase", value: value)
	}

	public static func prefix(field: String, value: Any) -> Filter {
		return Filter(field: field, op: "prefix", value: value)
	}

	public static func missing(field: String) -> Filter {
		return Filter(field: field, op: "missing", value: nil)
	}

	public static func exists(field: String) -> Filter {
		return Filter(field: field, op: "exists", value: nil)
	}

	public static func fuzzy(field: String, query: Any, fuzziness: Int = 1) -> Filter {
		let value: [String: Any] = [
			"query": query,
			"fuzziness": fuzziness
		]
		return Filter(field: field, op: "fuzzy", value: value)
	}

	public static func wildcard(field: String, value: String) -> Filter {
		return Filter(field: field, op: "wildcard", value: value)
	}

	func and(_ filters: [Filter]) -> Self {
		let ands: [[String: AnyObject]]
		if self.filter.isEmpty {
			ands = filters.map({ $0.filter })
		}
		else {
			ands = (filter["and"] as? [[String: AnyObject]] ?? [self.filter]) + filters.map({ $0.filter })
		}

		filter = [
			"and": ands as AnyObject
		]

		return self
	}

	func or(_ filters: [Filter]) -> Self {
		let ors: [[String: AnyObject]]
		if self.filter.isEmpty {
			ors = filters.map({ $0.filter })
		}
		else {
			ors = (filter["or"] as? [[String: AnyObject]] ?? [self.filter]) + filters.map({ $0.filter })
		}

		filter = [
			"or": ors as AnyObject
		]

		return self
	}

}

public func && (left: Filter, right: Filter) -> Filter {
	return left.and(filters: right)
}

public func || (left: Filter, right: Filter) -> Filter {
	return left.or(filters: right)
}

public prefix func ! (filter: Filter) -> Filter {
	return filter.not()
}
