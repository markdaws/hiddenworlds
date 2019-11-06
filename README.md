#  ARKit Demo

This demo uses ARKit to track an image and render a 3D box to look like a volumetric display.

NOTE: This code is not optimized, the images are too big and the app stutters when the models are loaded :) It's just for demo purposes.

![](./demo.png)

For a video, see this Tweet: https://twitter.com/markdaws/status/1191889540505489408

The 3D model is from Sketchfab: https://sketchfab.com/3d-models/pony-cartoon-885d9f60b3a9429bb4077cfac5653cf9

## How it works
If you open the project, and look in the Assets folder you will see a file called screenshot-full.

This image is used as the tracking image, I just took a full screen screenshot on my laptop, then when the app sees the same screen it tracks the image and I render the volumetric box behind it.

If you want to make this work for you, take a full screen screenshot on your computer, then replace screenshot-full with your own image (keeping the same name).

Tap on the screen to open/close the box.

