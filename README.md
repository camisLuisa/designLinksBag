# Menu Bar App Design Links Bag - Tutorial

## To Use

1. [Download App](https://drive.google.com/file/d/1ZwlISlWo5-rfOW1KMcgPDTLHDg04R3ow/view?usp=sharing);
2. Unzip the application;
3. Drop the .app in the Applications folder
4. To make the app open on every login in macOS, go to System Preferences -> Users and groups -> Login Items
5. Add the **designLinksBag.app** in Login Items list
6. Create the menu

## Requirements for creating and updating the menu

1. Download json file
2. Download and install Postman
3. After installing Postman:
  * Import json file
  * Browse to the data file named DesignLinksBag.postman_collection.json that was in the drive with the app
  * The request will appears on the Collections column:
  

## To create the menu:

**This is done only once.**

1. Click on DesignLinksBag -> Click on Create Menu:
2. Click on Body:
3. Configure the menu -> Click on Send:
4. Will appear behind the body a box with some informations that were created, one of these is the menu id:
5. Cope the sequence of numbers.
6. Now open the application folder and find the app.
7. Click on it to see more informations -> Click on Show Package Contents
8. Click on Contents -> Click on Resources -> Click on Settings.plist
9. Will appear this window:
10. Select the sequence of number and delete -> Paste the sequence numbers that was copied -> Click on enter;
11. Open the app from Applications folder. Your computer needs to be connected to the internet at the first time that you 12. install the app;

## To update menu items:

1. Click on DesignLinksBag -> Click on Update Menu:
2. Click on Body:
3. Do the alterations -> Click on Send:

## Menu Design Links Bag Json file

The menu consists of sections and items. A section is made up of items and subsections. The menu consists of only one level of subsections. The menu can contain as many sections and items as needed.

* A section has: Name and a list of items;
* A item has: Name and a link;
* A subsection has: Name and a list of sections;

## Example of a Menu Design Links Bag json code:

```json
{
  "items": [
    {
      "title": "itemName",
      "link": "https://link.com"
    },
    {
      "title": "sectionName1:",
      "itemList": [
        {
          "title": "itemName1",
          "link": "https://link.com"
        },
        {
          "title": "itemName2",
          "link": "https://link.com"
        }
      ]
    },
    {
      "title": "sectionName2:",
      "itemList": [
        {
          "title": "itemName1",
          "link": "https://link.com"
        },
        {
          "title": "subsectionName1",
          "itemList": [
            {
              "title": "sectionName1:",
              "itemList": [
                {
                  "title": "itemName1",
                  "link": "https://link.com"
                },
                {
                  "title": "itemName2",
                  "link": "https://link.com"
                }
              ]
            },
            {
              "title": "sectionName2:",
              "itemList": [
                {
                  "title": "itemName1",
                  "link": "http://link.com"
                },
                {
                  "title": "itemName2",
                  "link": "http://link.com"
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}
```

_Thanks to the Design and Mobile guilds of Liferay Recife which are great contributors to the project development._










