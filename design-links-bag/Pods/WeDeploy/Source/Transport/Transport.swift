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

public protocol Transport {

	func send(
		request: Request, success: @escaping ((Response) -> Void), failure: @escaping (Error) -> Void)

}

public class NSURLSessionTransport: Transport {

	public func send(
		request: Request, success: @escaping ((Response) -> Void), failure: @escaping (Error) -> Void) {

		let success = dispatchMainThread(success)
		let failure = dispatchMainThread(failure)

		let config = URLSessionConfiguration.ephemeral
		let session = URLSession(configuration: config)

		do {
			let request = try request.toURLRequest()

			session.dataTask(with:
				request,
				completionHandler: { (data, r, error) in
					if let e = error {
						failure(e)
						return
					}

					let httpURLResponse = r as! HTTPURLResponse
					let headerFields = httpURLResponse.allHeaderFields
					var headers = [String: String]()

					for (key, value) in headerFields {
						headers[key.description] = value as? String
					}

					let response = Response(
						statusCode: httpURLResponse.statusCode,
						headers: headers, body: data!)

					success(response)
				}
			).resume()
		}
		catch let e as NSError {
			failure(e)
			return
		}
	}

	func dispatchMainThread<T>(_ block: @escaping (T) -> Void) -> (T) -> Void {
		return { value in

			DispatchQueue.main.async {
				block(value)
			}
		}
	}

}
