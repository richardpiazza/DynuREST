# DynuREST

A Dynu.com IP Update API wrapper.

<p>
    <img src="https://github.com/richardpiazza/DynuREST/workflows/Swift/badge.svg?branch=main" />
    <img src="https://img.shields.io/badge/Swift-5.3-orange.svg" />
    <a href="https://twitter.com/richardpiazza">
        <img src="https://img.shields.io/badge/twitter-@richardpiazza-blue.svg?style=flat" alt="Twitter: @richardpiazza" />
    </a>
</p>

Face it... a REST API that responds in only text doesn't feel very modern. DynuREST translates the text responses from the Dynu.com IP 
Update API into propery HTTP status codes and meaningful errors.

## Installation

**DynuREST** is distributed using the [Swift Package Manager](https://swift.org/package-manager). To install it into a project, add it as a 
dependency within your `Package.swift` manifest:

```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/richardpiazza/DynuREST.git", from: "3.0.0")
    ],
    ...
)
```

Then import the **DynuREST** packages wherever you'd like to use it:

```swift
import DynuREST
```

## Usage

The `API` class provides two default implementations: `shared` & `insecure`. They target the **https** and **http** schemes respectively.

Setting authentication information is done using the `HTTP.Authorization` enum:

```swift
let username: String = ""
let password: String = ""
API.shared.authorization = .basic(username: username, password: password)
```

The `update()` function will execute the query and parse the `ResponseCode` returned.

```swift
API.shared.update(ip: "127.0.0.1") { (statusCode, headers, data, error) in
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
```

### Insecure Use

The previous version of the api.dynu.com SSL Certificate did not work with iOS11.0+ and macOS10.13+. 
In order to use an insecure connection, your app must explicitly bypass App Transport Security in your Info.plist.

```xml
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
```
