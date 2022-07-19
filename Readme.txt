required Toolbox:

* Image Processing Toolbox
* Optimization Toolbox

------------------

How to run the application:
** xxx** means the commands in the GUI surface.

1. run the APP
2.choose one image from this App by **Dataset**, or from user's computer by clicking **Load Custom Image**.
3.For setting up, the user can specify 3 main characters, (1st) when the picture has been rotated, the user can choose **rotation** as Yes and specify the line which should be horizontal, 
then type Enter to let the computer rotate in a position which will urge the rear wall to be a rectangular whose lines are either parallel  or vertical to the horizontal line.  
user must specify then the number of (2nd)** Vanish Point Number** and (3rd)**Foreground Number**;
 afterwards, user needs to choose left upper corner and right bottom corner to determine background window by left clicking in the picture, then choose a suitable vanishing point by
left clicking, user can try many times to determine the most suitable position of the vanishing point, then press Enter;
 after above that, it will present 4 trapezoids as ceiling wall, floor wall, left wall, right wall in the image, and a 3D scene in another figure.
** Stop** will end up our image processing immediately.
4.**GUI Model**: user can then translate the view of camera by switching to **Shift**  or  rotate by swtiching to **Rotate** in the GUI interface, and manipulate the value by cliking
the "arrow" , **Step Size** means step length, which is used to adjust the range of motion per step.
**Zoom in** and **Zoom out** are used to enlarge or shrink the view in the 3D model.
5.**Camera Position** : specify the position and pose of camera by user; pose is given by the **direction vector**. the user can give arbitrary parameters, 
and click **Apply**  to obtain different perspectives of  reconstructed 3D Model.


