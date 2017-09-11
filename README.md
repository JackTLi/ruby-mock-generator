# Desktop Mock Generator

Creates merchant mocks for Desktop view.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine to create the mocks.

### Prerequisites

What things you need to install the software and how to install them

```
Give examples
```

### Installing

A step by step series of examples that tell you have to get a development env running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Design Requirements

You can find the [sketch file](www.smile.io) that has been formated with the correct asset names.

The design assets that is required to run this script and the required naming conventions:

| Type of asset          | Name              | Notes                                         |
| ---------------------- |:-----------------:|:---------------------------------------------:|
| launcher               | Launcher.png      |                                               |
| referral receiver card | Program Cards.png |                                               |
| sign up card           | Signup.png        |                                               |
| background             | Background.png    | Used only if url doesn't pull image correctly |

### Notes: Details on what is required for Background.png

If the script can't pull the website properly please manually screenshot the website in the ratio 1902px x 1080px. Please name the file "Background.png"

```
Gif of how to screenshot on chrome
```

## How to use Script

You can download the [template](wwww.smile.io) here.

```
sites:
-
  url: shop.sho-products.com/
  # background: "Merchants/Merchant-Folder-Name/Background.png"
  wordpress: false
  launcher: "Merchants/Merchant-Folder-Name/Launcher.png"
  launcher_color: '#000000'
  orientation: "left"
  referral_receiver: "Merchants/Merchant-Folder-Name/Referral Receiver.png"
  program_card: "Merchants/Merchant-Folder-Name/Program Cards.png"
  signup: "Merchants/Merchant-Folder-Name/Signup.png"
```

### How to skip certain mocks

If the merchant does not need to have certain mocks you can skip by adding the string "skip". This string will only work for the types of assets listed below.

```
launcher: "skip"
referral_receiver: "skip"
program_card: "skip"
signup: "skip"
```

### How to change the launcher alignment

If you need to change the alignment of the launcher you can add the strong "left" or "right".

```
orientation: "left"
orientation: "right"
```

### How to change the launcher colour

If you need to change the launcher colour you can just write the hex code.

```
launcher_color: "#000000"
```

## To run the script

1. Open Terminal
2. Find the folder where you added ruby-mock-generator (you can use "cd folder_name" to go into the folder and "ls" to see which folders are available)
```
gif of how to use terminal
```
3. After you find ruby-mock-generator then type in "ruby background_generator.rb sample.yml"
```
gif of how to use terminal
```

## Built With


* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Acknowledgments

* This was created by Jack Li (github handle). lol this person doesn't work for Smile.io
