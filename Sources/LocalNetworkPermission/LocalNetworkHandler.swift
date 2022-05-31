// The MIT License (MIT)
// Copyright © 2020 Sparrow Code LTD (https://sparrowcode.io, hello@sparrowcode.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#if PERMISSIONSKIT_LOCALNETWORK
import Foundation
import Network

class LocalNetworkHandler: NSObject, NetServiceDelegate {
    
    var completion: ()->Void = {}
    var isEnabled: Bool?
    
    // MARK: - Init
    
    static let shared: LocalNetworkHandler = .init()
    
    override init() {
        super.init()
    }
    
    // MARK: - Manager
    
    private var netService: NetService?

    func reqeustUpdate() {
        self.isEnabled = nil
        let parameters = NWParameters()
        parameters.includePeerToPeer = true
        
        self.netService = NetService(domain: "local.", type:"_http._tcp.", name: "LocalNetworkPrivacy", port: 8080)
        self.netService?.delegate = self
        self.netService?.publish()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            self.reset()
        }
    }
    
    private func reset() {
        self.netService?.stop()
        self.netService = nil
        completion()
    }

    func netServiceDidPublish(_ sender: NetService) {
        isEnabled = true
        self.reset()
    }
    
    func netServiceDidStop(_ sender: NetService) {
        guard isEnabled == nil else {
            return
        }
        
        isEnabled = false
    }
}
#endif
