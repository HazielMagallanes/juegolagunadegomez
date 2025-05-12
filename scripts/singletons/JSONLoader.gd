extends Node
func loadJson(path: String) -> Dictionary:
	if FileAccess.file_exists(path):
		var dataFile = FileAccess.open(path, FileAccess.READ);
		var parsedResult = JSON.parse_string(dataFile.get_as_text());
		if parsedResult is Dictionary:
			return parsedResult;
		else:
			printerr("JSON Format is incorrect.");
			return {};
	else:
		printerr("JSON file not found.");
		return {};
