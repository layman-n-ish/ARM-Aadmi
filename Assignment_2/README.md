## Q1 - Exponential Series
An iterative approach was taken to implement the Taylor Series approximation to the exponential function. Emperical results were considered to fix on the number of terms to be expanded to. Of course, the more the terms better the approximation but one can keep a 'tolerance' on the change in the approximation after including another term. Any change below the 'tolerance' and the subsequent terms can be ignored. 

- For upto **30 terms**, with **float** values (32-bit single precision), the execution time to compute exp(x) is around **60 microsecs**.
- exp(x), for x > 25, results in **inf** in the FPU (for single precision). 
- The interesting approach of incorporating a table lookup method (without multiplications!) as done [here](https://www.quinapalus.com/efunc.html) would be an immensenly quicker method although the trade-off there would be storage space (to store the table!). The infamous trade-off of **space vs time** manifests itself here too! 

### The plot: 

![Exponent series](https://github.com/layman-n-ish/ARM-Aadmi/blob/master/Assignment_2/plots/exp_series.png)

Note: Series2 is extracted from Google Calculator (can be verified by anyone easily) and Series3 is extracted from my code's output. [BinaryConverter](https://www.binaryconvert.com/convert_float.html) was used to get the conversion from float to decimal. 

## Q2 - Tangent Series
An iterative approach was taken to implement the tangent function by taking the Taylor Series approximation of sine and cosine and then simply dividing those. Again, emperical results were considered to fix on the number of terms to be expanded to. Only **10 terms** were chosen as it was enough for the 'tolerance' on the change I imposed and moreover for more terms either sin(x) or cos(x) goes to **inf** (register shows **NaN**)! 

- For upto **10 terms**, with **float** values (32-bit single precision), the execution time to compute exp(x) is around **40 microsecs**.

### The plot: 

![Tangent series](https://github.com/layman-n-ish/ARM-Aadmi/blob/master/Assignment_2/plots/tan_series.png)

Note: Series2 is extracted from Google Calculator (can be verified by anyone easily) and Series3 is extracted from my code's output. [BinaryConverter](https://www.binaryconvert.com/convert_float.html) was used to get the conversion from float to decimal.

Note: The above plot is for 0 to 2 * pi radians. 

***

The ./plots/ directory consists the .csv's with the extracted values (and the plots as well). 
- The first column is the value of 'x'.
- The second column corresponds to values provided by the Google Calculator. 
- The third column corresponds to values extracted from my code. 
