extends Node2D

@onready var gemini_request: HTTPRequest = $HTTPRequest

func _ready() -> void:
	OS.shell_open("C:/Users/ezrag/OneDrive/Documents/sgme-ai-1.0/ai/ai.py")

func send_to_gemini(user_input: String):
	var url = "http://127.0.0.1:5000/generate" # Adjust if your Flask app runs on a different port
	var headers = PackedStringArray(["Content-Type: application/json"])
	var body = JSON.stringify({"prompt": user_input})
	
	gemini_request.request(url, headers, HTTPClient.METHOD_POST, body)


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result == OK and response_code == 200:
		var json_response = JSON.parse_string(body.get_string_from_utf8())
		if json_response and json_response.has("response"):
			var ai_response = json_response["response"]
			print("Gemini Response:", ai_response)
			$TextEdit2.text = ai_response # Set the TextEdit's text
			$TextEdit.text = ""
			# Update your UI or game logic with the AI response
		else:
			printerr("Error parsing Gemini response:", body.get_string_from_utf8())
	else:
		OS.alert("API is Missing: Could not find ai.py running.")
		printerr("Gemini request failed:", result, response_code)
		printerr("Headers:", headers)
		printerr("Body:", body.get_string_from_utf8())


func _on_button_pressed() -> void:
	send_to_gemini($TextEdit.text)
