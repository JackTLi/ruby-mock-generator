## Getting Started

These instructions will get you a copy of the project up and running on your local machine to create the mocks.

### Prerequisites

1. Text editor [Atom](https://atom.io/). This will be used to edit your **sample.yml** file
2. Open terminal and install homebrew
  ```
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  ```
3. Install wget by running the following:
  ```
  brew install wget
  ```
4. Install phantomjs by running the following:
  ```
  brew install phantomjs
  ```
5. Download [repository](https://github.com/smile-io/smile-mock-image-generator) and put the folder **ruby-mock-generator** into your Documents

## Design Requirements

1. Download [sketch template](https://www.dropbox.com/s/g6u1c7wafzpcpne/Script%20Template.sketch?dl=0)
2. After you have finished your designs export your assets and you will have two folders **Mocks** and **Assets**. The only folder that you will need is **Mocks**, while **Assets** will be given to Success Managers to upload assets.
<!-- This [sketch file](www.smile.io) has been formatted with the correct asset names, so use this as the base. Just click export in sketch and you will have a folder with the name "Mocks" and "Assets". -->

<!-- The design assets that is required to run this script and the required naming conventions:

| Type of asset          | File Name         | Notes                                         |
| ---------------------- |:-----------------:|:---------------------------------------------:|
| launcher               | Launcher.png      |                                               |
| referral receiver card | Program Cards.png |                                               |
| sign up card           | Signup.png        |                                               |
| background             | Background.png    | Use only if url doesn't pull assets correctly | -->

<!-- ### Notes: Details on what is required for Background.png

If the script can't pull the website properly please manually screenshot the website in the ratio 1902px x 1080px. Please name the file "Background.png"

```
Gif of how to screenshot on chrome
``` -->
## How to use Script

1. Add **Mocks** into the **Merchant** folder, you can rename **Mocks** to the merchant name (E.g. Smile)
2. Go to **ruby-mock-generator** and open **sample.yml**
3. Edit the variables

```
# Merchant's website. If any errors occur you can manually add in an image (1920px x 1080px) of the website with the file name Background.png and place it in folder with the rest of the assets.
url: https://smile.io

add image of the settings

# Launcher alignment. It can either be from the right or left. Choose one from below.
orientation: "left"
orientation: "right"

# Launcher colour.
launcher_color: '#000000'

# Location of all your assets
asset_path: "Merchants/Smile"
```

## To run the script

1. Open Terminal
2. Find the folder where you added ruby-mock-generator (you can use "cd folder_name" to go into the folder and "ls" to see which folders are available)
3. After you find ruby-mock-generator then type
```
ruby background_generator.rb sample.yml
```

## Built With


* [WGet](https://www.gnu.org/software/wget/) - Part of the GNU Project, wget has a flag that allows downloading of a webpage along with all of its required assets. It will also embed referenced scripts and styles inline into the html file.
* [Ruby](https://www.ruby-lang.org/en/) - Quick scripting, meat and potatoes are here.
* [PhantomJS](http://phantomjs.org/) - Allows us to render webpages in a headless browser and take screenshots of the results.

## Acknowledgments

* This was created by [Jack Li](https://github.com/jacktli). lol this person doesn't work for Smile.io
