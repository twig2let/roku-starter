⚠ Please check out my newer, more modern and fully featured BrighterScript starter template [here](https://github.com/twig2let/roku-brighterscript-starter)

<hr/>
# Roku Hello World

This is a barebones scaffold for writing Roku applications.

## Getting Started

### Prerequisites

* Node.js (minimum version **v10.0.0**)
* Yarn (minimum version **v1.22.0**)
* Create a `.env` file in the root of the project with the following properties:

```
ROKU_DEV_TARGET=192.168.1.123
ROKU_DEV_USERNAME=rokudev
ROKU_DEV_PASSWORD=rokudev
```
See the [Roku Setup Guide](https://blog.roku.com/developer/developer-setup-guide) for details on enabling the Roku developer mode.

And finally, if you are using Visual Studio Code then install the Brightscript Langugage plugin:

* $ code --install-extension celsoaf.brightscript or https://marketplace.visualstudio.com/items?itemName=celsoaf.brightscript#review-details

* Install the project dependencies:

    $ `yarn`

## Deploying the Application

This starter supports two ways of deploying the application

1. $ `gulp deploy`
2. In VSC, use the "Deploy & Debug" Run command. This method supports interactive breakpoints as standard.



## Running Rooibos Unit Tests

TBC
