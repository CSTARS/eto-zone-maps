# Classification Methodology

We will try a method that we call median subtraction to develop our
maps.  This has multiple benefits.  First, we can guide the
classification so that we can describe the tolerable error within any
given class.  Second, we can start the classification process at
sensible location, In our case, we use the statewide median eto curve
as our starting point.  We can watch each new classification step as
it comes in, and decide whether we need to add any expert knowledge
into the classfication scheme.  Finally, we can decide to not include
certain classifications if there are too few pixels in that region.
The outliers can be assigned to their closest classfication, but if
needed, we can identify these outlying pixels.  This classification
scheme should push high error pixels to the edges of the
classification polygons, which is what you would expect and what makes
sense to the users of the maps.

This method also can show us the total error, and maximum error for
any number of classifications.

The methodology is quite simple.  We first determine the median ETo
curve for the state of California.  From this median we calculate the
state average curve parameters, e[0-2] and d[1-2].  Using these
parameters, we calculate the RMSE error for each pixel within the
state. RMSE is calculated using the 52 wk, 15 day running average
calculations of ETo.

RMSE = \frac{\Sum_{n=0}^{N} (eto_n - eto(e\bar,d\bar))^2}{N}

_Note, we could additionally use only a growing season RMSE, or most
generally, we can use a weighted RMSE, where we also include a weight
term, w_n at each $n$th week.

At this point we can plot the RMSE for the entire state, to see how
the error is spatially distributed.

We then set our acceptable error for the our classification.  From
this we can mask out those pixels that lay within those error bars.
The remaining pixels can be clustered into what side of the median
values their components lie.  We can either cluster them into 2^5 (32)
categories, or we can use a single parameter, eg. $e0$, or whichever
parameter most evenly divides the outliers.

Using these clustered pixels, we can once again 