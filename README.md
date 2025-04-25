# Disney Take Home Challenge

## Introduction
The initial requirements were to make a SwiftUI interface to the marvel web services: [https://developer.marvel.com/](https://developer.marvel.com/)

But I was met at the time with issues
1. The registration part of the developer portal was not working
2. I was having issues trying to authorize my requests to the web services despite following their instructions (something I had done before in previous challenges)

Notwisthstanding that wand with the opportunity to use this exercise as an excuse to try out some tech that I had not used before and was very interested in, namely [Swift OpenAPI Generator](https://github.com/apple/swift-openapi-generator), I endeavoured on and decided to make a simple web search and details display app based instead on the [MyAnimeList API](https://docs.api.jikan.moe/#section/Information). This time though instead of creating my own web client I intended to use and document my experience with the Swift OoenAPI Generator package and plugins.

## Running The Code
After cloning the repo and opening XCode it should start downloading the depndency packages but you might not be in the clear yet to run the code. Please make sure to go to the **`Build Phases`** settings of the **`DisneyTakeHome`** target and verify / add the **`swift-openapi-generator`** plugin:

![Screenshot 2025-04-25 at 11 19 54 AM](https://github.com/user-attachments/assets/470f13c6-79bf-4951-87f3-e2063f790aa3)

This will process the **`openapi.yaml`** and **`openapi-generator-config.yaml`** files and generate the model and service clients for the app.

The DisneyTakeHome app itsetlf should build for iPhone / iPad / MacOS and VisionOS and I tested it on all simulators.

The unit test can be run on its own and all it does is verify that no errors were thrown by the service client.

Finally the UI Test can also be run and it should execute through a simple process of searching for an Anime and taking screenshots of the results of each interaction.

## Development Notes
Probably the longest thing that took getting used to was to set up the openapi.yaml file. The MyAnimeList API had an [OpenAPI spec file](https://raw.githubusercontent.com/jikan-me/jikan-rest/master/storage/api-docs/api-docs.json) available but I noticed it was too complex and extensive for waht I needed. I just wanted the part of the API that performed a search of Anime titles. So I pared the file down and got it to just that service. I had to go through some grief to do this though as there was some point where the data from the web service was not being deserialized correctly and I was getting those errors in a unit test I had created. I found out by using PostMan and by following the schema of the openapi.yaml file that a propery called **`type`** was configured in the schema to be of certain values defined by an enumeration...

![Screenshot 2025-04-25 at 10 49 05 AM](https://github.com/user-attachments/assets/16e54d6e-ab6e-4088-8628-0d48972b5ca8)

But PostMan revealed that the data had a **`type`** with a value that existed outside the enumeration: **`TV Special`**

![Screenshot 2025-04-25 at 10 50 04 AM](https://github.com/user-attachments/assets/6864fca7-c59c-4ef1-a312-12fa32de8593)

So I removed the enum part of the schema inside the openapi.yaml and forced it to be any odd string...

![Screenshot 2025-04-25 at 10 55 40 AM](https://github.com/user-attachments/assets/37b0749d-df8d-4d49-8ac7-f982e33f4716)

This allowed the unit test to pass and ultimately the app to get built.

Unlike the Marvel API I did not need to add keys to the MyAnimeList API but should I have needed to I would kave defined keys inside a Swift enum which I would have named **`Configuration`** and put those into either the request header or as part of the URL query (the traditional places they are put in code). I normally embed keys in the code and not put them in a config file or a web service that is later ingested by the app.
