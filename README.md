# MacModels

A list of Mac devices with easy-to-use API.

This project is using [MacModelDump](https://github.com/phimage/MacModelScraper)'s 
code for the internal Apple Support website scraper, to power the fetching of devices
from the web. 

## Installation

You are really adviced to use the `branch: "master"` way
of resolving the version, because each time you refetch
your dependencies, this package might get updated, and
with that update an updated local list of models will be
there, which allows for you to not constantly check for 
the version and update it yourselves.

## API

The API is pretty simple, you can fetch all devices from the web by using 
`MacModels.getAllDevicesOnline()`, and getting a specific model by using
`MacModels.getDeviceOnline(by:)`. You can also do this locally by using 
`MacModels.getAllDevicesLocally()` and `MacModels.getDeviceLocally(by:)` respectively.
There is also a preffered method of retrieving a specific device, which is
`MacModels.getDevice(by:)`, because it is utilizing the online list only when the device
is not found locally, which results in less internet usage.

Note that the web APIs are `async`, so you can use them only in an async environment.
