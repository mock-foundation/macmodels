# Updates the models.json file

git clone https://github.com/phimage/MacModelDump.git

cd MacModelDump
swift run modelappledump json | python3 -m json.tool > ../Sources/MacModels/Resources/models.json
