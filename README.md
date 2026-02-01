# DynuREST

A Dynu.com IP Update API wrapper.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Frichardpiazza%2FDynuREST%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/richardpiazza/DynuREST)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Frichardpiazza%2FDynuREST%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/richardpiazza/DynuREST)

Face it... a REST API that responds in only text doesn't feel very modern. DynuREST translates the text responses from the Dynu.com IP 
Update API into proper HTTP status codes and meaningful errors.

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
