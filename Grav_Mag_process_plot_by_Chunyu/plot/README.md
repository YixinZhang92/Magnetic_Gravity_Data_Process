# The tutorial to use plot_cen_maggrav
- Bouguer gravity anomaly
- Reduce to pole magnetic anomaly
- total/dtrend magnetic field
- upward/downward continuation, 1st order vertical derivative, 2nd order vertical derivative, directional derivative
- all above processes could be use in gravity and magnetic field


# Simple commands to extract all you need
## Complete bouguer anamaly
```
-   ./plot_cen_maggrav -92 -87 35 38.5 1 complete_bouguer 1 
```
![complete_bouguer](../Output_Png/complete_bouguer.png)
## 2km upward continuation
```
-   ./plot_cen_maggrav -92 -87 35 38.5 1 complete_bouguer_up_continuation 2 
```
![up_continuation1](../Output_Png/complete_bouguer_up_continuation.png)
## Gravity 1st order vertical derivative
```
-   ./plot_cen_maggrav -92 -87 35 38.5 1 complete_bouguer_1st_order_vertical_derivative 3 
```
![1st_derivative1](../Output_Png/complete_bouguer_1st_order_vertical_derivative.png)
## Gravity 2nd order vertical derivative
```
-   ./plot_cen_maggrav -92 -87 35 38.5 1 complete_bouguer_2nd_order_vertical_derivative 4 
```
![2nd_derivative1](../Output_Png/complete_bouguer_2nd_order_vertical_derivative.png)
## Gravity 90 degree clockwise from north directional derivative
```
-   ./plot_cen_maggrav -92 -87 35 38.5 1 complete_bouguer_directional_derivative 5 
```
![directional_derivative1](../Output_Png/complete_bouguer_directional_derivative.png)
## Reduce to pole magnetic anomaly
```
-   ./plot_cen_maggrav -92 -87 35 38.5 2 RTP 1 
```
![RTP](../Output_Png/RTP.png)
## Magnetic field
```
-   ./plot_cen_maggrav -92 -87 35 38.5 3 magnetic 1 
```
![magnetic](../Output_Png/magnetic.png)
## Magnetic 2km upward continuation
```
-   ./plot_cen_maggrav -92 -87 35 38.5 3 magnetic_up_continuation 2 
```
![up_continuation2](../Output_Png/magnetic_up_continuation.png)
## Magnetic 1st order vertical derivative
```
-   ./plot_cen_maggrav -92 -87 35 38.5 3 magnetic_1st_order_vertical_derivative 3 
```
![1st_derivative2](../Output_Png/magnetic_1st_order_vertical_derivative.png)
## Magnetic 2nd order vertical derivative
```
-   ./plot_cen_maggrav -92 -87 35 38.5 3 magnetic_2nd_order_vertical_derivative 4 
```
![2nd_derivative2](../Output_Png/magnetic_2nd_order_vertical_derivative.png)
## Magnetic 90 degree directional derivative
```
-   ./plot_cen_maggrav -92 -87 35 38.5 3 magnetic_directional_derivative 5  
```
![directional_derivative2](../Output_Png/magnetic_directional_derivative.png)
# Directional derivative variation with azimuth (video clip)

[![video](../Output_Png/video.jpg)](https://drive.google.com/file/d/1gqYfQjx6byjadlzNMgdxRJFd5_lfwn-F/view?usp=sharing)
