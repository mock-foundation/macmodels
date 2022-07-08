# Updates the models.json file

git clone https://github.com/phimage/MacModelDump.git
cd MacModelDump

# Generates the list of devices, prettifies it, and then saves to models.json file
swift run modelappledump json | python3 -m json.tool > ../Sources/MacModels/Resources/models.json
