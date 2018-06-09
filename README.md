# xccovstats

A command line utility, written in Swift, for extracting and interpreting stats from Xcode code coverage reports.

## Installing dependencies

You'll need to have Xcode command line tools installed and Xcode version 9.3 or later. The test run is hard-coded in this script to use iOS v11.4 but you can change that in the code as required.

Use Swift Package Manager to install dependencies:

```
swift package update
```

## Running the app

To run the app, go to the root directory of this repository and run:

```
swift run xccovstats --workspace "Path to workspace" --scheme "Scheme name"
```

Example:

```
swift run xccovstats --workspace "~/Code/my-great-app/my-great-app.xcworkspace" --scheme "my-great-app"
```

## Building the app

If you need to build the app:

```
make build
```

## Running the tests

Run the following command to execute tests:

```
make test
```

## Generating an Xcode project file

If you change the `Package.swift` file you should regenerate the Xcode project file by running:

```
swift package generate-xcodeproj
```

## Running the app after installing to `/usr/local/bin/`

First install the app to `/usr/local/bin/` by running:

```
make install
```

Run the app with the following command from anywhere:

```
xccovstats --workspace "Path to workspace" --scheme "Scheme name"
```

## To Do

* Make the app more resilient to Xcode build failures
* Allow skipping the build phase and pointing to a coverage file directly
