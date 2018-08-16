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
import SocketIO

public class SocketIOClientFactory {

	public class func create(
			url: String, params: [URLQueryItem]? = [], auth: Auth? = nil,
			options: inout SocketIOClientConfiguration)
		-> SocketIOClient {

		if !options.contains(.forceNew(false)) {
			options.insert(.forceNew(true))
		}

		let urlComponents = parseURL(url: url, params: params)

		options.insert(.connectParams(["EIO": "3", "url": urlComponents.query]))
		options.insert(.path(urlComponents.path))
		if let auth = auth {
			options.insert(.extraHeaders(auth.authHeaders))
		}

		let socket = SocketIOClient(socketURL: URL(string: urlComponents.host)!, config: options)
		socket.connect()

		return socket
	}

	class func parseURL(url: String, params: [URLQueryItem]? = [])
		-> (host: String, path: String, query: String) {

		let URL = NSURLComponents(string: url)!
		URL.queryItems = params

		let host = URL.host ?? ""
		var port = ""

		if let p = URL.port, URL.port != 80 {
			port = ":\(p)"
		}

		let path = URL.path!
		let scheme = "\(URL.scheme ?? "http")://"
		var query = path

		if let q = URL.query {
			query = "\(path)?\(q)"
		}

		return ("\(scheme)\(host)\(port)", path, query)
	}

}
