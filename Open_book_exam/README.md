## Directory Structure:
```
--- get_trig_fn.s
--- make_circle.s
--- printMsg.c
--- plot_script/
     |
     ->-- plot_circles.py
--- plots/ 
     |
     ->-- *.txt
     ->-- *.png
```

## File Description:
get_trig_fn.s : Given an angle in radians, computes sine and cosine of that angle.

make_circle.s : Given the centre co-ordinates, radius and the resolution 
of the angle (in degrees), spits out the locus of points lying on the  circle.

plot_circles.py : Uses matplotlib to plot graphs of the data provided in a .txt file.

printMsg.c : C program to print register values onto the 'Debug Viewer'.

## Approach:

- The approach to compute the sinusoids is given in the folder ../Assignement_2/. 
Please refer it for any doubts.

- To find the locus of a point in the circle, I compute the co-ordinates of the 
point using polar co-ordinates: x = x_centre + (radius * cos(theta)) and
y = y_centre + (radius * sin(theta)) where theta = 0:resolution:360 (in degrees)
i.e., theta starts from '0' and is incremented by 'resolution' till it reaches '360'. 

- The plots/*.txt were created by simply saving the output from the 'Debug Viewer' for different resolutions
and different MAX_TERMS for Taylor series expansion of the sinusoids. 

## Note:
I use **VCVT** to convert from float to int (since pixels are discrete) **finally**
to discard any intermediate "rounding-off" problem. Although, even after that, one
can see the "elliptical" plot below which I believe is caused due to conversion between 
float and int. 

## Results:

Centre -> (320, 240)

Radius -> 5

Resolution -> 1 (degree)


![Circles](https://github.com/layman-n-ish/ARM-Aadmi/blob/master/Open_book_exam/plots/circle.png)
