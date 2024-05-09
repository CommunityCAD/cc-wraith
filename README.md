# FiveM Wraith ARS 2X Script

Wraith ARS 2X automated plate reading for Community CAD

## Install

- Download the latest version
- Rename the folder to `cc-wraith`
- Drag into your `resources` folder
- Start `cc-wraith`


## Configuration

The resource includes one config file to get you up and running.

### `config.lua`

- `cadURL`: The URL of your CAD - Example `https://demo.communitycad.app/api/v1/emergency/vehicle_lookup`
- `apiKey`: Your CAD API key 
- `showExpirationDate`: Show expiration date of vehicle - True/False
- `vehicleTypeFilter`: Vehicle classes that will not be returned. You can find the classes [here](https://wiki.rage.mp/index.php?title=Vehicle_Classes)
- `noRegistrationAlerts`: If a car is not registered in the CAD do not show the alert for it. - True/False



## Dependencies

- [`wk_wars2x`](https://github.com/WolfKnight98/wk_wars2x): This resource is required to Read the Plates. Please make sure its started.
    - Note for the wk_wars2x config. Make sure `CONFIG.use_sonorancad = true` is `true`. This Will Prevent AI Vehicles from being scanned even with Community CAD.
- [`pnotify`](https://github.com/Nick78111/pNotify): This resource is required to send notifications!

## Usage

Scan Or Lock onto a Plate!
