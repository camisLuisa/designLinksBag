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

public class WeDeploy: RequestBuilder {

	override public class func url(_ url: String) -> WeDeploy {
		return WeDeploy(url)
	}

	public class func auth(_ url: String, authorization: Auth? = nil) -> WeDeployAuth {
		let url = validate(url: url)

		return WeDeployAuth(url, authorization: authorization)
	}

	public class func data(_ url: String, authorization: Auth? = nil) -> WeDeployData {
		let dataUrl = validate(url: url)

		return WeDeployData(dataUrl, authorization: authorization)
	}

	public class func email(_ url: String, authorization: Auth? = nil) -> WeDeployEmail {
		let emailUrl = validate(url: url)

		return WeDeployEmail(emailUrl, authorization: authorization)
	}

	class func validate(url: String) -> String {
		var finalUrl = url
		if !url.hasPrefix("http://") && !url.hasPrefix("https://") {
			finalUrl = "https://" + finalUrl
		}

		if url.hasSuffix("/") {
			let slashIndex = finalUrl.index(finalUrl.endIndex, offsetBy: -1)
			finalUrl = String(finalUrl[..<slashIndex])
		}

		return finalUrl
	}
}
