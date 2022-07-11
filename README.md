# MacModels

A list of Mac devices with easy-to-use API.

This project is using [MacModelDump](https://github.com/phimage/MacModelScraper)'s 
code for the internal Apple Support website scraper, to power the fetching of devices
from the web. 

## API

The API is pretty simple, you can fetch all devices from the web by using 
`MacModels.getAllDevices()`, and getting a specific model by using
`MacModels.getDevice(by:)`. You can also do this locally by using 
`MacModels.getAllDevicesLocally()` and `MacModels.getDevice(by:)` respectively.

Note that the web APIs are `async`, so you can use them only in an async environment.
