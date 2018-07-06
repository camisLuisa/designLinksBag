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
import PromiseKit
import SocketIO

public class WeDeployData: WeDeployService {

	var query = Query()
	var filter: Filter?

	public override func authorize(auth: Auth?) -> WeDeployData {
		return super.authorize(auth: auth) as! WeDeployData
	}

	public override func header(name: String, value: String) -> WeDeployData {
		return super.header(name: name, value: value) as! WeDeployData
	}

	public func create(resource: String, object: [String: Any]) -> Promise<[String: AnyObject]> {

		return doCreateRequest(resource: resource, object: object)
			.then { response in
				try response.validate()
			}
	}

	public func create(resource: String, object: [[String: Any]]) -> Promise<[String: AnyObject]> {

		return doCreateRequest(resource: resource, object: object)
			.then { response in
				try response.validateBody(bodyType: [String: AnyObject].self)
			}
	}

	public func update(resourcePath: String, updatedAttributes: [String: Any]) -> Promise<Void> {
		return requestBuilder
			.path("/\(resourcePath)")
			.patch(body: updatedAttributes)
			.then { response in
				try response.validateEmptyBody()
			}
	}

	public func replace(resourcePath: String, replacedAttributes: [String: Any]) -> Promise<Void> {
		return requestBuilder
			.path("/\(resourcePath)")
			.put(body: replacedAttributes)
			.then { response in
				try response.validateEmptyBody()
			}
	}

	public func delete(collectionOrResourcePath: String) -> Promise<Response> {
		return requestBuilder
			.path("/\(collectionOrResourcePath)")
			.delete()
	}

	public func createCollection(name: String, fieldTypes: [String: CollectionFieldType]) -> Promise<[String: Any]> {
		let body: [String: Any] = [
			"mappings": fieldTypes.toJsonConvertible(),
			"name": name
		]

		return requestBuilder
			.post(body: body)
			.then { response in
				try response.validateBody(bodyType: [String: Any].self)
			}
	}

	public func updateCollection(name: String, fieldTypes: [String: CollectionFieldType]) -> Promise<Void> {
		let body: [String: Any] = [
			"mappings": fieldTypes.toJsonConvertible(),
			"name": name
		]

		return requestBuilder
			.patch(body: body)
			.then { response in
				try response.validateEmptyBody()
			}
	}

	public func filter(filter: Filter) -> Self {
		self.filter = filter
		return self
	}

	public func query(query: Query) -> Self {
		self.query = query
		return self
	}

	public func `where`(field: String, op: String, value: Any) -> Self {
		filter = getOrCreateFilter().and(filters: Filter(field: field, op: op, value: value))
		return self
	}

	public func `where`(filter: Filter) -> Self {
		self.filter = getOrCreateFilter().and(filters: filter)
		return self
	}

	public func or(field: String, op: String, value: Any) -> Self {
		filter = getOrCreateFilter().or(filters: Filter(field: field, op: op, value: value))
		return self
	}

	public func orderBy(field: String, order: Query.Order) -> Self {
		query = query.sort(name: field, order: order)
		return self
	}

	public func limit(_ limit: Int) -> Self {
		query = query.limit(limit: limit)
		return self
	}

	public func offset(_ offset: Int) -> Self {
		query = query.offset(offset: offset)
		return self
	}

	public func count() -> Self {
		query = query.count()
		return self
	}

	public func aggregate(name: String, field: String, op: String, value: Any? = nil) -> Self {
		let aggregation = Aggregation(name: name, field: field, op: op, value: value)
		query = query.aggregate(aggregation: aggregation)
		return self
	}

	public func aggregate(aggregation: Aggregation) -> Self {
		query = query.aggregate(aggregation: aggregation)
		return self
	}

	public func highlight(_ fields: String...) -> Self {
		query = query.highlight(fields: fields)
		return self
	}

	public func fields(_ fields: String...) -> Self {
		query = query.fields(fields: fields)
		return self
	}

	public func search(resourcePath: String) -> Promise<[String: AnyObject]> {
		query = query.search()
		return doGetRequest(resourcePath: resourcePath)
			.then { response in
				try response.validate()
			}
	}

	public func get(resourcePath: String) -> Promise<[[String: AnyObject]]> {
		return get(resourcePath: resourcePath, type: [[String: AnyObject]].self)
	}

	public func get<T>(resourcePath: String, type: T.Type = T.self) -> Promise<T> {
		return doGetRequest(resourcePath: resourcePath)
			.then { response in
				try response.validateBody(bodyType: T.self)
			}
	}

	public func watch(resourcePath: String) -> SocketIOClient {
		if let filter = filter {
			query = query.filter(filter: filter)
		}

		let url = "\(self.url)/\(resourcePath)"
		var options = SocketIOClientConfiguration()

		let socket = SocketIOClientFactory.create(url: url, params: query.query.asQueryItems,
				auth: authorization, options: &options)

		query = Query()
		filter = nil

		return socket
	}

	func doGetRequest(resourcePath: String) -> Promise<Response> {
		if let filter = filter {
			query = query.filter(filter: filter)
		}

		let request = requestBuilder

		if query.query.count != 0 {
			request.params =  query.query.asQueryItems
		}

		query = Query()
		filter = nil

		return request.path("/\(resourcePath)")
			.get()
	}

	func getOrCreateFilter() -> Filter {
		if let filter = filter {
			return filter
		}

		return Filter()
	}

	func doCreateRequest(resource: String, object: Any) -> Promise<Response> {
		return requestBuilder.path("/\(resource)")
			.post(body: object)
	}
}
