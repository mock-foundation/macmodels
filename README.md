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
`MacModels.getAllDevices()`, and getting a specific model by using
`MacModels.getDevice(by:)`. You can also do this locally by using 
`MacModels.getAllDevicesLocally()` and `MacModels.getDevice(by:)` respectively.

Note that the web APIs are `async`, so you can use them only in an async environment.

### When to use which?

It is preferred that you use the offline methods,
and if they don't contain the info you are
searching for, then use the web API. As an example,
let's use `getDevice(by:)`:

You first run `getDeviceLocally(by:)`, if there is a value,
then use it, if not, then use the web API as a fail safe.
By the way, a convenience method will soon appear in this
package to do this exact thing, to first try locally, and
then use the web API if not found.
