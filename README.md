<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<base target="_blank" />

# Register Panel Configurations

## Introduction

This project contains configuration files for another project: [Register Panel](https://github.com/FooFooDamon/regpanel).
Since there are countless chips in real world, and they are and will be increasing all the time,
which means it's nearly impossible to gather all register data of them, not to mention doing it all by myself.
Therefore, this project comes up.

## Installation and Uninstallation

* Install this project before using [Register Panel](https://github.com/FooFooDamon/regpanel):
    ````
    $ sudo make link # Or: sudo make copy
    ````

* Uninstall it if you don't need it any more:
    ````
    $ sudo make unlink # Or: sudo make remove
    ````

## Rules of Configuration<a id="conf_rules"></a>

* Path hierarchy:
    * Convention: `<Vendor>`/`<Chip>`/`<Group>.json`
    * Example: rockchip/rk3588/mipi.json

* JSON example:
    ````
    {
        "__addr_bits__": 16, // Should be one of: 8, 16, 32 or 64
        "__data_bits__": 32, // Same as above.

        "__maintainers__": [
            "YourName <YourEmail>" // There can be multiple maintainers.
        ],

        // Modules that can be divided into the same group (JSON file).
        // For example: CSI Host and CSI D-PHY in MIPI group.
        "__modules__": [
            "Module 1",
            "Module 2" // , 3, 4, ... and so on, but it's recommended to give each of them a descriptive name.
        ],

        "Module 1": {
            "__prefix__": "<PREFIX_OF_MODULE_1>_", // Not used so far.

            "__defaults__": {
                // "<Register Address or Offset> | <Descriptive Name of This Register>": "<Non-Zero Default Value>"
                // Note: There's no need to write out items with default value of zero.
                "0x0000 | Reg1": "0x01010000",
                "0x0002 | Reg2": "0x11110202" // , More default values ...
            },

            /*
             * Register items below.
             *
             * Convention of an array item:
             *
             * // If bit definitions of a register are totally the same as those of another register,
             * // use this.
             * { "ref": "<key of another register>" }
             *
             * Or:
             *
             * {
             *      "attr": [
             *          "<high bit>[:<low bit>]",   // Required. Example 1: "7:4"; Example 2: "2"
             *          "<read-write permission>",  // Required. Should be RO or RW.
             *          "<type>",                   // Required. Should be one of:
             *                                      //      reserved
             *                                      //      todo
             *                                      //      enum: enumerable description items stored in a drop-down list box
             *                                      //      bool: boolean: 0 for false, 1 for true
             *                                      //      invbool: inverse boolean: 0 for true, 1 for false
             *                                      //      decimal: signed decimal number (not supported yet)
             *                                      //      udecimal: unsigned decimal number
             *                                      //      hex: hexadecimal number
             *          "<name of this bits item>", // Optional, not needed if type is reserved or todo
             *          "<hover tip>"               // Optional, detailed description of this bits item
             *      ],
             *      "desc": { // Only required by enum type.
             *          "<hex number or asterisk (*) key>": "<descriptive string value>"
             *      }
             * }
             */

            "0x0000 | Reg1": [
                { "attr": [ "31:24", "RO", "reserved" ] },
                { "attr": [ "23:16", "RW", "udecimal", "version:" ] },
                { "attr": [ "15:8", "RW", "decimal", "voltage:", "Normal voltage in mV" ] },
                { "attr": [ "7:4", "RW", "hex", "level:", "Weird level displayed with hexadecimal number." ] },
                { "attr": [ "3", "RW", "bool", "func1_active_high" ] },
                { "attr": [ "2", "RW", "invbool", "func2_active_low" ] },
                {
                    "attr": [ "1:0", "RW", "enum", "frequency:", "Currently only support 100Hz and 1000Hz" ],
                    "desc": {
                        "0": "100Hz",
                        "1": "1000Hz",
                        "*": "Invalid freq" // Asterisk (*) means the rest of keys, which are 2 and 3 in this case.
                    }
                },
            ],

            "0x0002 | Reg2": [
                // There should be one and only one dictionary (map) item.
                { "ref": "0x0000 | Reg1" }
            ],

            "0x0004 | Reg3": [
                { "attr": [ "31:0", "RO", "todo" ] }
            ]
        },

        "Module 2": {
            // Similar to contents of Module 1.
        }
    }
    ````
    **NOTE**: Standard JSON might not support comments,
    remember to remove them while you mean to write a real configuration file.

## How to Contribute

* Read [Rules of Configuration](#conf_rules) above.

* Make a one-shot contribution: Submit a pull request.

* Or become a long-term maintainer: Send an E-Mail to ask for project privileges.

* Last but not least, all contributions are welcome and appreciated.

## License

`Apache-2.0`

