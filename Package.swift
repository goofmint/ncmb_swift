// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "NCMB",
  products: [
    .library(name: "NCMB", targets: ["NCMB"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(name: "NCMB", dependencies: [], path: "NCMB")
  ]
)