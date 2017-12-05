# Documentation for Magnetic Gravity Data Process code by Chuck Langston


This code computes a gravity anomaly for a polygon drawn by the user. 

  - Draw a polygon representing a gravity anomaly
  - Put the polygon at different depths to view impact of depth on gravity anomalies.
  - Change the density contrast to see its impact on gravity anomalies.

## Drawing a polygon

The polygon extends in the y direction (in and out of the screen) to model a linear feature. The user controls the size, depth, and profile of the linear feature by drawing polygons, and can adjust the density contrast with controls in the user interface.

## To open the GUI and run the program:

1) Download the files and open in Matlab.
2) Press “Save and run” to start the GUI.

## Drawing a polygon

The polygon extends in the y direction (in and out of the screen) to model a linear feature. The user controls the size, depth, and profile of the linear feature by drawing polygons, and can adjust the density contrast with controls in the user interface.

To draw a new polygon:

1) Select “New” to begin drawing a polygon.
2) Draw vertices by clicking in the gridded area. For example, drawing a circle will create a cylindrical anomaly extending in the y-direction.
3) Adjust density contrast as needed.
4) Press “Compute Anomaly” to calculate the gravity anomaly and see the anomaly in the plot.
5) Add more polygons by pressing following steps 1-4, or press “Initialize” to delete all polygons.


![](/high.png?raw=true "Circle at shallow depth")

![](/low.png?raw=true "Circle at deep depth")

