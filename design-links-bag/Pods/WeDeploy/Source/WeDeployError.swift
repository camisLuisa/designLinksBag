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

public struct WeDeployError: Error, CustomDebugStringConvertible {

	let code: Int
	let message: String

	let errors: [(reason: String, message: String)]

	public var debugDescription: String {
		let errorsString = errors.map { "reason: \($0) message: \($1)" }
		return "Code: \(code)\nmessage: \(message)\nErrors: \(errorsString)"
	}

	public static func errorFrom(response: Response?) -> WeDeployError {
		guard let body = response?.body as? [String: AnyObject],
			let code = response?.statusCode,
			let message = body["message"] as? String,
			let errorsArray = body["errors"] as? [AnyObject]
		else {
			return WeDeployError(
					code: response?.statusCode ?? -1,
					message: response?.body as? String ?? "No response body from the server",
					errors: [])
		}

		let errors = errorsArray
			.map { err -> (reason: String, message: String) in
				let errorDict = err as! [String: String]
				return (reason: errorDict["reason"] ?? "", message: errorDict["message"] ?? "")
			}

		return WeDeployError(code: Int(code), message: message, errors: errors)
	}
}

public enum WeDeployProviderError: Error {
	case noAccessToken
}

extension WeDeployProviderError: CustomStringConvertible {
	public var description: String {
		return "No access token found in the url"
	}
}
