import PackageDescription

let package = Package(
    name: "Synchronizable",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/Quick/Quick", "v0.9.3"),
        .Package(url: "https://github.com/Quick/Nimble", "v4.1.0")
    ]    
)
