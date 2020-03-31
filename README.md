# Roku Starter

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

* Install the project dependencies:

    $ `yarn`

## Deploying the Application

$ `gulp deploy`