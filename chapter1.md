# Poplar Water Use

Here we are interested in determining the total amount of poplar water use.  The idea here is to compare the Penman-Monteith version of ET in the 3PG model with the Kc tests that have been performed in (Gochis 2000)


## Fourier Transform

There are two different ways to think about the CIMIS fourier transform.  One, we can combine all ten years together and compute the transform once, or we can calculate the transform for all years, and combine the results.  Remember, we are only interested in the zeroth and first transform values (for each year).


$$X_k= \sum\limits_{n=0}^{N-1} x_n(cos(-2\pi k \frac{n}{N})+j~ sin(-2\pi k \frac{n}{N})), n \in Z $$

Now, lets imagine we have 10 years of weekly data, $$N=52$$. If we calculate each year seperately, we get: 

$$X_k= \sum\limits_{n=0}^{N-1} x_n, n \in \mathbb{Z} $$

and 

$$P_k= \sum\limits_{n=0}^{N-1} x_n~cos(-2\pi \frac{n}{N})$$

$$\Phi_k= \sum\limits_{n=0}^{N-1} x_n~sin(-2\pi k \frac{n}{N})$$

Where P, and \Phi are the power and phase respectively. Now consider instead, I was using all 10 years together.  Clearly, $$X_0$$ is just the sum of the yearly versions above.  For $$P_1$$, we are interested in the 10th power of the transform, the

$$P_{10} = \sum\limits_{n=0}^{10*N-1} x_n~cos(-2\pi 10 \frac{n}{10N})$$
$$P_{10} = \sum\limits_{n=0}^{N-1} x_n~cos(-2\pi \frac{n}{N}) + \sum\limits_{n=N}^{2N-1} x_n~cos(-2\pi \frac{n}{N}) + \ldots$$

$$P_{10} = P_{1}^{1}+P_{1}^{2}+\ldots$$

Where $$P^n_1$$ is the first power of the $$n$$th year.  This means that we can calculate the individual powers separately, and combine them together to get average values.


