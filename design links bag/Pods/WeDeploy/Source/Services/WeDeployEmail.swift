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

public class WeDeployEmail: WeDeployService {

	var params: [(name: String, value: String)] = []

	public override func authorize(auth: Auth?) -> WeDeployEmail {
		return super.authorize(auth: auth) as! WeDeployEmail
	}

	public override func header(name: String, value: String) -> WeDeployEmail {
		return super.header(name: name, value: value) as! WeDeployEmail
	}

	public func from(_ from: String) -> Self {
		params.append(("from", from))
		return self
	}

	public func to(_ to: String) -> Self {
		params.append(("to", to))
		return self
	}

	public func subject(_ subject: String) -> Self {
		params.append(("subject", subject))
		return self
	}

	public func message(_ message: String) -> Self {
		params.append(("message", message))
		return self
	}

	public func priority(_ priority: Int) -> Self {
		params.append(("priority", "\(priority)"))
		return self
	}

	public func replyTo(_ replyTo: String) -> Self {
		params.append(("replyTo", replyTo))
		return self
	}

	public func cc(_ cc: String) -> Self {
		params.append(("cc", cc))
		return self
	}

	public func bcc(_ bcc: String) -> Self {
		params.append(("bcc", bcc))
		return self
	}

	public func send() -> Promise<String> {
		var builder = requestBuilder
				.path("/emails")

		for param in params {
			builder = builder.form(name: param.name, value: param.value)
		}

		return builder
			.post().then { response in
				try response.validateBody(bodyType: String.self)
			}
	}

	public func checkEmailStatus(id: String) -> Promise<String> {
		return requestBuilder
			.path("/emails/\(id)/status")
			.get()
			.then { response in
				try response.validateBody(bodyType: String.self)
			}
	}

}
