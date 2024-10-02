## What

(2024-09)

`arduino-cli`-based scripts to compile, upload and start serial monitor
for Arduino Uno connected through USB.


## Why

*Scenario*. I've just made changes to sketch and want to compile it.
Then (if it is compiled) upload to `/dev/ttyUSB0`. Then start serial
monitor for that port at `57600` baud.

This is very typical and there is only one real way to do this:

* `gcc`, `avrdude`, `screen`

  Compile with `gcc`, upload with `avrdude`. Terminal program is
  variable, let it be `screen`.

  But there hella lot of parameters for `gcc`.

  So people created `Arduino IDE`

* `Arduino IDE`

  Click "compile", click "upload", click "serial monitor".
  Real easy, I've used it for years.

  But later idgaf to their IDE with code editor. I just wanted
  compile, upload and monitor.

  I believe I wasn't alone, so `arduino-cli` existed when I
  came to it

* `arduino-cli`

  ```
  arduino-cli compile --fqbn arduino:avr:uno .
  arduino-cli upload --fqbn arduino:avr:uno --port /dev/ttyUSB0
  arduino-cli monitor --port /dev/ttyUSB0 --config baudrate=57600
  ```

  Clean command interface, I've used is for several years.

  But later I wanted to add additional compilation flags, assume board
  name, assume USB port index.

  So I wrote my custom scripts..


## `ino`

  ```
  ino
  ```

  Yeah, just like HQ9+ language! It does exactly what is said in scenario.

  But it is reasonably configurable and consists of parts:

  * Compile

    ```
    ino.pile
    ```

  * Upload

    ```
    ino.load 1
    ```

    Upload to `/dev/ttyUSB1`. Use `0` or drop argument for `/dev/ttyUSB0`

  * Monitor

    ```
    ino.mon 1 115200
    ```

    Serial monitor for `/dev/ttyUSB1` at `115200` baud.

    Defaults are `/dev/ttyUSB0` and `57600` baud.


## Base library

All `arduino-cli`-related functionality is located in `acli_wrappers.sh`.
Those ino's are just callers and parameter jugglers.

I encourage you to change implementation. Not design (I think design
is okay).

Your stock Arduino firmware not compiles because of `-Werror`?
Remove it! Using 115200 or 9600 by default? Change defaults!


## Other boards

It's fixed to Arduino Uno. For other boards, I'd use another names
for external callers. `lora` sounds neat for Esplora btw.


## Where to install?

I'm using `~/bin` (`bin` directory in home directory) for my scripts.
Typical location is `/usr/local/bin` tho.


## See also

* [My other repositories](https://github.com/martin-eden/contents)
