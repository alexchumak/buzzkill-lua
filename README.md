# buzzkill-lua
A simple Lua library to play notes and frequencies on NodeMCU ESP8266

NOTE: Calling notes by their letter is experimental right now. Suggestions and modifications are welcome in a pull request form. Using frequencies is recommended at this point as notes and their frequencies may change.

# Usage

### Simple

```lua
local buzzer_pin = 1
local buzzer = require("buzzkill").setup(buzzer_pin)

-- play two sounds for 200ms and 100ms
buzzer({ { note = 'a', duration = 200 }, { frequency = 1000, duration = 100 } })
```

### More Control

```lua
local buzzkill = require('buzzkill')
local buzzer_pin = 1
local buzzer1 = buzzkill.setup(buzzer_pin)
local notes = { { note = 'a', duration = 200 }, { frequency = 1000, duration = 100 } }

buzzer1(notes)

-- play one note on pin 2, with a callback when done playing
buzzkill.playNote(2, notes[1], function() print("Finished playing") end)

-- play multiple notes on pin 3, with a callback and a custom delay between notes of 100ms
buzzkill.playNotes(3, notes, function() print("Done!") end, 100)
```

# API

### #playNotes(pin_number, array_of_notes, callback, custom_delay)

1. `pin_number` - The pin number that your buzzer is on
1. `array_of_notes` - An array of Lua tables with each having either a `note` or a `frequency` specified and a `duration`. Examples of single notes: `{ note='a', duration=100 }` or `{ frequency=1000, duration=200 }`.
1. `callback` - Optional, this will get called when all the notes are done playing
1. `custom_delay` - Optional, by default it is 10ms but you can specify a custom one here

### #playNote(pin_number, note, callback)

It's simply a wrapper for `playNotes` that accepts one note instead of an array of them.
