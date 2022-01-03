---
title: Building inventory UI
---

!!! info "Requirements to build:"

    * Node.js
    * Yarn

!!! info "Installing Node.js:"

    * Download the LTS version of Node.js from [here](https://www.nodejs.org).
    * Go through the install and make sure you install all of the features.
    * Run node --version in cmd and make sure that it gives you the version number. If it doesn't then you didn't install it correctly.

!!! info "Installing Yarn:"

    * Now that you've installed Node.js you can install Yarn by running `npm install --global yarn` in cmd.

!!! info "Building the inventory UI:"

    * cd into the web directory of ox_inventory
    * In your cmd type `yarn` and in will start downloading the node modules.
    * After it's done downloading node modules you can run `yarn build` to build the UI.

!!! tip "Hot reloads"
    When working in the browser you can run `yarn start`, which supports hot reloads meaning that
    you will see your changes after saving your file.

    If you want to work in game you can run `yarn start:game` which writes changes to disk, so
    the only thing you have to do is restart the resource for it take affect. 