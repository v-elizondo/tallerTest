# Taller Tech iOS Code Challenge
This is my implementationn of the requested coding challenge .

## Installation
1. Clone the repository to safe location into your computer.
2. Navigate to RedditReader directory
3. Open RedditReader.xcodeproj which will launch your Xcode with this implementation

## XCode version used for Development
xCode v13.2.1

## Features included
- List Top Reddits with thumbnails
- Pull to refresh Reddits
- Load more Reddits when reaching end of list
- Support for different device resolutions and orientation

## Features under development not included in the latest MAIN
- Display Reddit details (only for reddits with images in PNG and JPG format)
- Save Reddit image into photo library

## Solution

In order to comply with the requirements, I've developed a project from scratch using Swift and quickly following a minimal MVVM architecture to solve the prescribed problem. 

Based on the fact that no 3rd Party Software or libraries are allowed for this implementation, I've taken the time to implement a basic Network Manager relying in the power provided by URLSession and URLRequests.

### Networking Layer (Data Access Layer / Model)

##### Extending URLRequest and URLSession

For the networking layer the first customization done is an extension of the URLRequest in order to create a request with concatenated parameter and the specified HTTP method that we need. This extension is also tested in the UnitTests section of the project.

Also, there's an extension of a URLSession adding an additional function to fetch the required data from a customized request and providing a response. This extension takes advantage of Generics in prder to create a general purpose fetching function that we can reuse among different API calls by specifing the type of data we want to decode from the response once needed.

This implementation can be found in the Extensions directory.

#### Defining the Model 

Another important part of the networwking layer are the Decodable structs which handles the serialization of the JSON response. These struct used Decodable as this is the most apropiate convention for data that needs to be decoded from a JSON stream. We can also use Codable, but this is just a type alias that covers the usage of Encodable and Decodable protocols. In this specific case we just to decode data, so we use the specific protocol for it.

This implementation can be found in the Networking/Responses directory.

#### Defining a Shared Network Manager Utility

In this step, I decided to create a shared component which will use the extended funtionality of URLSession. This shared manager is though as a separate place in which each API endpoint call is added. As you can see in Networking/NetworkManager.swift, this class is in charge of adding functions that will call an specific API method and handle it as an Async call using GCD. Once the async task has completed, the control is given back to the main thread and I decided to provide the parsed elements as a closure so the element using it can have the desired Model Data already parsed.

An important part of the Networking Layer is also creating some Network constants to keep track of the baseHost URL, the endpoints, the HTTPMethods available as well as the possible parameters to be used by the endpoints. For the sake of this implementation of the infinite scrolling required (pagination), there's just one parameter added to the constants file which is the 'after' one.

### Utilties for Async Image Loads

Part of the required specifications is to show the thumbnail of each Reddit. In order to avoid blocking the main thread (the UI), I've added another extension for async image downloads. In this case, I've created an extension for the UIKit component ImageView in which I provide the desired URL image to load and also a placeholder image. Placeholder image is the first data that will be shown on every imageView while we wait for the async task to complete the download.

This implementation also takes in cosiderationg that if an invalid URL is provided or the URL fails, then there's always an image to show to the useer so he/she can notice that reddit doesn't have an specified image. Some unsuppported data that comes from the API are in the form of string stating: 'default' or 'nsfw' from the tests I've made.

### UI Implementation (View Layer)

In order to show correctly all the top Reddits, I've decided to use a customized TableViewController added completely programatically so we can have complete control of the UI we want to add. Also, there's a customized UITableViewCell to show the thumbnail and the title of each reddit item into the table view.

This implementation can be found in the Controllers directory.

ViewControllers in iOS development are in charge of just interacting with the UI (views) and either updating the provided content or reacting to some actions from the user on the UI components.

One of the required actions is a pull to refresh feature, in which I've added a refresh control to the TableView to handle this behaviour. Every time an user pulls to refresh, this provides a call to the viewModel indicating it to fetch the latest 25 records provided by the API endpoint.

Another feature of the UI is the infinite scrolling. For this feature, I've used a Datasource method called UITableViewDataSourcePrefetching. This allows me to validate once the user is scrolling to the bottom of the table view and validate if it's reaching to the end of the current data in order to ask for the next 25 items from the API endpoint.

An important part of the UI development is also having a Constants file in which I can keep track easily of the text I'm adding to the labels, size constants, margings and other values that can be easily found in Utils/Constants

### ViewModel Implementation (Logic)

This layer is the one that connects with the viewController and receives all the action calls provided by the controller. This is the layer in which we do all logic connections and incorporate the usage of the Network Manager to gather the data needed to show (provided already parsed) and once this data arrive, the viewModel launches a delegate call indicating that the UI should be updated.

As you can notice in the directory ViewModels/TopRedditViewModel.swift, this implementation keeps track of the parsed dataModel and also the state of the latest page that has been requested to the API, so the infinite scrolling can keep asking for the next pages until no more information is provided in the "after" parameter of the response. 

Also you might notice there are 2 methods to request information. One is the first call of the API data which will bring the first 25 items and this will be called once the UI is loaded for the first time or if the pull to refresh element is activated. The other call is to "loadMoreData" which will use the state of the latest requested page to ask for the next 25 items and append them to the dataModel. Every time the dataModel is updated, a delegate call is invoked which will trigger an UI update in the viewController to show the data accordingly.

All these Data and UI updates are correctly handled in the corresponding threads so the user can continue scrolling without any delay or freeze in the UI and as soon as the background queues completes their tasks, the images and data are reflected correctly.
