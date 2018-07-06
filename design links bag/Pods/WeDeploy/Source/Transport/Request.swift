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

public class Request {

	var body: Any?
	var headers: [String: String]
	var method: RequestMethod
	var params: [URLQueryItem]
	var url: String

	init(
		method: RequestMethod = .GET, headers: [String: String]?, url: String,
		params: [URLQueryItem]?, body: Any? = nil) {

		self.method = method
		self.headers = headers ?? [:]
		self.headers["X-Requested-With"] = "api.swift"
		self.url = url
		self.params = params ?? []
		self.body = body
	}

	func setRequestBody(request: inout URLRequest) throws {
		guard let b = body else {
			return
		}

		if let stream = b as? InputStream {
			request.httpBodyStream = stream
		}
		else if let string = b as? String {
			request.httpBody = string.data(using: .utf8)
		}
		else {
			request.setValue(
				"application/json", forHTTPHeaderField: "Content-Type")

			request.httpBody = try JSONSerialization.data(withJSONObject: b)
		}
	}

	func toURLRequest() throws -> URLRequest {
		let URL = NSURLComponents(string: url)!
		URL.queryItems = params

		var request = URLRequest(url: URL.url!)
		request.httpMethod = method.rawValue

		for (name, value) in headers {
			request.addValue(value, forHTTPHeaderField: name)
		}

		try setRequestBody(request: &request)

		return request
	}

}
