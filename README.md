# FiveM Wraith ARS 2X Script

Wraith ARS 2X automated plate reading forCommunity CAD

## Install

- Download the Latest Version
- Rename the folder to `cc-wraith`
- Drag Into your `resources` Folder
- Start `cc-wraith`


## Configuration

The resource includes one config file to get you up and running!

### `config.lua`

- `cadURL`: The URL Of Your CAD - Example https://demo.communitycad.app/api/v1/emergency/vehicle_lookup
- `apiKey`: Your CAD API Key 
- `showExpirationDate`: Show Expiration Date of Vehicle - True/False
- `vehicleTypeFilter`: Vehicle Classes that Will Not Be Returned View Classes [here](https://wiki.rage.mp/index.php?title=Vehicle_Classes)
- `noRegistrationAlerts`: If A Car is not Registered, Return it that its not



## Dependencies

- [`wk_wars2x`](https://github.com/WolfKnight98/wk_wars2x): This resource is required to Read the Plates! Please make sure its started!
    - Note for the wk_wars2x config. Make sure `CONFIG.use_sonorancad = true` is `true`. This Will Prevent AI Vehicles from being scanned even with Community CAD!
- [`pnotify`](https://github.com/Nick78111/pNotify): This resource is required to send notifications!

## Usage

Scan Or Lock onto a Plate!