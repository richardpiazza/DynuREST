# DynuREST
[![Version](https://img.shields.io/cocoapods/v/DynuREST.svg?style=flat)](http://cocoadocs.org/docsets/DynuREST)
[![Platform](https://img.shields.io/cocoapods/p/DynuREST.svg?style=flat)](http://cocoadocs.org/docsets/DynuREST)

Face it... a REST API that responds in only text doesn't feel very modern. DynuREST translates the text responses from the Dynu.com IP Update API into propery HTTP status codes and meaningful errors.

#### API.swift

Provides a wrapper around CodeQuickKit.WebAPI that expands for a username/password credential combination. The `update()` function will execute the query and parse the `ResponseCode` returned.

Typical use:

    let api = API(username: "username", password: "password")
    api.update(ip: "127.0.0.1") { (statusCode, headers, data, error) in
        guard error == nil else {
            // Process Error
            return
        }
        
        guard statusCode < 300 else {
            // Non-OK response
            return
        }
        
        // All good
    }

Insecure use:

The current version of the api.dynu.com SSL Certificate does not work with iOS11.0 and macOS10.13. In order to execute updates, an insecure HTTP connection must be used. In order to use this connection, your app must explicitly bypass App Transport Security in your Info.plist.

    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSExceptionDomains</key>
        <dict>
            <key>api.dynu.com</key>
            <dict>
                <key>NSExceptionAllowsInsecureHTTPLoads</key>
                <true/>
            </dict>
        </dict>
    </dict>

#### ResponseCode.swift

A reprsentation of the status codes that should be returned from the Dynu.com API. Use the init(stringValue:) with the test response fo parse the correct response.

#### String.swift

An extension of Swift.String with regex pattern matching of IPv4 and IPv6 address.
