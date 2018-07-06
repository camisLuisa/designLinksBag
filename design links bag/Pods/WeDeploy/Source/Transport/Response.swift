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

public class Response {

	public private(set) var body: Any?
	public let headers: [String: String]
	public let statusCode: Int

	public var contentType: String? {
		return headers["Content-Type"]
	}

	public var succeeded: Bool {
		return (statusCode >= 200) && (statusCode <= 399)
	}

	init(statusCode: Int, headers: [String: String], body: Data) {
		self.statusCode = statusCode
		self.headers = headers
		self.body = parse(body: body)
	}

	func parse(body: Data) -> Any? {
		if contentType?.range(of: "application/json") != nil {
			do {
				let parsed = try JSONSerialization.jsonObject(with: body, options: .allowFragments)

				return parsed
			}
			catch {
				return parseString(body: body)
			}
		}
		else {
			return parseString(body: body)
		}
	}

	func parseString(body: Data) -> String? {
		var string: String?

		if !body.isEmpty {
			string = String(data: body, encoding: .utf8)
		}

		return string
	}

	func validate() throws -> [String: AnyObject] {
		return try validateBody(bodyType: [String: AnyObject].self)
	}

	func validateBody<T>(bodyType: T.Type? = T.self) throws -> T {
		guard isSucceeded() else {
			throw WeDeployError.errorFrom(response: self)
		}
		guard let body = body as? T else {
			let message = "You are trying to cast the body of response into \(type(of: T.self)), " +
				"but it can't be done, please check the type of the response"

			throw WeDeployError(code: -1, message: message, errors: [])
		}

		return body
	}

	func validateEmptyBody() throws {
		guard isSucceeded() else {
			throw WeDeployError.errorFrom(response: self)
		}

		return ()
	}

	func isSucceeded() -> Bool {
		return 200 ..< 300 ~= statusCode
	}

}
