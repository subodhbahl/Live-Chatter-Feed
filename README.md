Live Chatter Feed
=================

This project will give you components that will allow you to have a live chatter feed for any annual event you have. This is built with native forcedotcom components i.e. visualforce and Apex. 

##Features
1. The feed will autorefresh from the configuration which is saved inside the custom setting
2. The feed will display the body, the creator, time it was created. The code to show the group name is commented out in the Visualforce page but can be used if suits your requirement.
3. The feed also renders image type attachments to the post, but if there is no body then the image does not come up 
4. The image renders up in the original size of 120x90, but if clicked opens up the 720x480 in the new tab
5. The user can click on the image of the creator to go to their profile as well

##Architecture & Components
![Alt Text] (https://raw.github.com/subodhbahl/Live-Chatter-Feed/master/Chatter%20Live%20Feed%20Architecture.jpg)

From the picture its clear how this whole thing will work. There is 3 components to this whole structure:

1. The visualforce page and controller
2. The container which returns a JSON
3. The custom setting which houses the configuration

Please also note that I have written the unit tests for these classes and put up in this repo.

##What to expect
![Alt Text] (https://raw.github.com/subodhbahl/Live-Chatter-Feed/master/Screenshot.jpg)

Above is a screenshot of how the feed looks like.
Please note that if the custom setting specifies the refresh time, it might take a bit longer to refresh the feed. 

##How to use

##How to Modify
