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
import RxSwift

public class RequestBuilder {

	var authorization: Auth?
	var headers = [String: String]()
	var path = ""
	var transport: Transport = NSURLSessionTransport()
	var formFields = [String: String]()
	var requestMethod: RequestMethod = .GET
	var body: Any?

	var params = [URLQueryItem]()

	var url: String {
		return _url + path
	}

	var _url: String

	public init(_ url: String) {
		self._url = url
	}

	public class func url(_ url: String) -> RequestBuilder {
		return RequestBuilder(url)
	}

	public func param(name: String, value: String) -> Self {
		params.append(URLQueryItem(name: name, value: value))
		return self
	}

	public func header(name: String, value: String) -> Self {
		var newValue = value
		if let currentValue = headers[name] {
			newValue = "\(currentValue), \(value)"
		}
		headers[name] = newValue
		return self
	}

	public func transport(_ transport: Transport) -> Self {
		self.transport = transport
		return self
	}

	public func authorize(auth: Auth?) -> Self {
		self.authorization = auth
		return self
	}

	public func path(_ path: String) -> Self {
		self.path += path
		return self
	}

	public func form(name: String, value: String) -> Self {
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		formFields[name] = value

		body = formBody()

		return self
	}

	public func get() -> Promise<Response> {
		requestMethod = .GET

		return doCall()
	}

	public func post(body: Any? = nil) -> Promise<Response> {
		requestMethod = .POST

		if body != nil {
			self.body = body
		}

		return doCall()
	}

	public func patch(body: Any? = nil) -> Promise<Response> {
		requestMethod = .PATCH

		if body != nil {
			self.body = body
		}

		return doCall()
	}

	public func put(body: Any? = nil) -> Promise<Response> {
		requestMethod = .PUT

		if body != nil {
			self.body = body
		}

		return doCall()
	}

	public func delete() -> Promise<Response> {
		requestMethod = .DELETE

		return doCall()
	}

	func doCall() -> Promise<Response> {
		return Promise<Response> { fulfill, reject in
			let request = Request(
				method: self.requestMethod, headers: self.headers, url: self.url,
				params: self.params, body: self.body)

			self.authorization?.authenticate(request: request)

			self.transport.send(request: request, success: fulfill, failure: reject)
		}
	}

	private func formBody() -> String? {
		guard !formFields.isEmpty else {
			return nil
		}

		return formFields.reduce([]) { (result, element: (key: String, value: String)) -> [String] in
			result + [element.key + "=" + (element.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
					?? element.value)]
		}
		.joined(separator: "&")
	}

}
