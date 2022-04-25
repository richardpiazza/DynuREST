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
Update API into proper HTTP status codes and meaningful errors.

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

The `DynuIPUpdater` shared instance allows for sending IP information to the Dynu.com API.

```swift
let address = IPAddress.ipV4("X.X.X.X")
let response = try await DynuIPUpdater.shared.updateAddress(address, using: .basic("username", "password"))
```

IP address information can be obtained through any means, but **DynuREST** has two built-in providers:
* `IPifyClient.shared`
* `IFConfigClient.shared`

These both implement the `IPSource` protocol:
```swift
public protocol IPSource {
    func ipAddress() async throws -> IPAddress
}
```

---

`DynuIPUpdater` also contains a helper method which will automatically retrieve IP information from the built-in sources.
```swift
func requestIP(_ sources: [IPSource]) async -> [IPAddress]
```
