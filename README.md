# Marvel API ColdFusion Component

---

This package is a ColdFusion wrapper written to interact with the Marvel API.

## Authors

Developed by Matt Gifford (aka coldfumonkeh)

- http://www.mattgifford.co.uk
- http://www.monkehworks.com


### Share the love

Got a lot out of this package? Saved you time and money?

Share the love and visit Matt's wishlist: http://www.amazon.co.uk/wishlist/B9PFNDZNH4PY 

---

## Requirements

The Marvel API package requires ColdFusion 8+


## Getting Started

To get started with the API you will need to sign up for a [free account at developer.marvel.com](http://developer.marvel.com) and receive your public and private key values which are required for API authentication.


### Instantiate the CFC

Once you have your public and private keys you simply need to pass them in to the **init()** method of the component during instantiation like so:

    <cfset objMarvel = new marvelAPI.com.coldfumonkeh.marvel.MarvelAPI(
        public_key = '<your public key>',
        private_key = '<your private key>',
        parseResults = true
    ) />

The **parseResults** parameter is an optional boolean value. 
When set to **true** all responses from the API are returned as a ColdFusion struct (converted from the JSON response).
When **false**, the response will be returned as the literal JSON string intended by the Marvel API Gods.

The following is an example to get all available characters:

    <cfset strResponse = objMarvel.getCharacters() />
    
Simple, right?

Let's filter this by character name:

    <cfset stuResponse = objMarvel.getCharacters(name='Spider-Man') />
    
    
#### Dealing with covers and images

The API gives you the ability to obtain and output images such as cover artwork in various sizes.

An example response from the API will include a struct or JSON child object that contains the image path and extension like so:

    {
      path = 'http://i.annihil.us/u/prod/marvel/i/mg/3/40/4bb4680432f73',
      extension = 'jpg'
    }

The CFC has a public method called **generateImage()** which accepts the image data structure / object (containing the path and extension) as a required parameter.
The second parameter is the size of the image to return in the form of a URL friendly descriptor.
For example, a standard aspect ratio medium image (100x100) is **'standard_medium'**.

Make the call like so:

    <cfset strImageSource = objMarvel.generateImage(stuImageData, 'standard_medium') />
    
The response from this will be a formatted URL string for the image of the desired / selected size:

    http://i.annihil.us/u/prod/marvel/i/mg/3/40/4bb4680432f73/standard_medium.jpg
    
"Why is there a method to handle this? It seems pointless."

The **generateImage()** method exists because the image size is an optional parameter. It will check it's existence for you before generating the correct URL string ready for you to insert into your awesome app.
Using this function means that you don't have to build the string yourself as the process to do so has been included for you.

I'm nice like that.
    

### Hinted beyond belief

All of the methods and arguments (whether required or not) have been fully hinted and documented to match the [documentation](http://developer.marvel.com/docs) from the API.
This means that you can make the most of the hints and details when in your IDE (especially when code hinting is available), when inspecting the component in your browser to generate the documentation or when reading the source code.

_Note: There may be some victims of copy and paste until all of the API methods have been included and I've tidied up the notes and hint attributes accordingly. It is what it is._


### Still to do

The following sections are still to do and will be complete by Tuesday 4th February:

* events
* series
* stories

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/coldfumonkeh/marvelapi/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

