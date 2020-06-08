package com.martinscholz.cloudexperts.helloworldrest;

import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

	@GetMapping("welcome")
	public String serve(@RequestHeader Map<String, String> headers) {
		String response = "Welcome to the world of never ending clouds...\n";
		for (String key : headers.keySet()) {
			response = response.concat("\n".concat(key).concat(": ").concat(headers.get(key)));
		}
		return response;
	}
}
