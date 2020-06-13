# Elixir Nerves RFID reader / GraphQL demo
A project to read RFID tags and hit a GraphQL API with the tag information.

The code is very contrived and lacking in some response and error handling, and authentication/environment setup. It was written to quickly validate an idea. It is mostly functional but needs work.

This project uses Elixir, via [Elixir Nerves](https://www.nerves-project.org/). 

## Electronics
### Components list
I utilised a simple RFID reader PCB (SunFounder RC522) and an Arduino uno for this project. Though any Nerves compatible target platform and serial RFID reader would work with minor tweaks.

- [RC552 Mifare reader](https://www.littlebird.com.au/products/mifare-rc522-card-read-antenna-rf-module-rfid-reader-ic-card-proximity-module)
- [Arduino uno](https://www.littlebird.com.au/products/arduino-uno-r3)
![alt text](arduino-example.png "Title")

### Wiring
Wiring is very simple, just follow the pinouts on the RC522 spec sheet.  

