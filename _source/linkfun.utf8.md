---
title: 'Link Functions: Where do they come from?'
author: "Danny"
date: "3/30/2020"
output:
  html_document: default
  pdf_document: default
---



As a student presented with the concept of link functions I was always left wanting a bit more. The standard way a social science student usually learns about link functions is through the introduction of logistic regression. In this post, I will attempt to provide an earlier version of myself what I always wanted - a step-by-step break down of how the logit link function is derived. In a future post, I'll expand on the conceptual aspects of link functions - introducing roughly, how probability enters generalized linear models which is paramount for understanding link functions.  
  
Of note, we'll be dealing with link functions in specific scenarios. First, we'll be dealing with the canonical link function, only. For instance, the logit is the cannonical link to the binomial whereas the probit is not. Roughly speaking, this means that the logit link can be directly derived from the binomial whereas the probit link cannot. Ironically, probit regression was more widely used than logistic regression. 

We'll be using a lot of algebra - there will be a hint of calculus. If this isn't your cup of tea, perhaps the next post will be more interesting. But, I try to explain all the steps below in a way that I hope is clear, including the "rules" I'm using through each step - so give it a shot! I think a little effort doing algebra can serve most of us students in social science more than we realize. 

## Preliminaries:

I'll refer to these rules in the post below. 

1. When I use $log$ I mean the natural log, or $ln$ . This is the logarithm with base $e$ such that $log_e(1) = 0$ because $e^0 =1$ . 
2. $log(a) + log(b) = log(a*b)$ .
3. $log(a)-log(b) = log(\frac{a}{b})$ .
4. $log(a)^x = xlog(a)$ .


## Exponential Family of Probability Functions
A generalized linear model's link function takes the "structural" component of the model and links it to the outcome. To expand, even when you have a standard linear regression of the form,

$$y_i = \alpha + \beta_1X_{1i }+ \epsilon_i$$  
y has some conditional distribution, an error distribution. In other words, we need to have some way to go from the structural portion of the model, $$\alpha + \beta_1X_1$$, which is just a straight line, and link it to its outcome $y$ via some probability density function because we are not dealing with deterministic data, afterall. In this case, we have an $\epsilon$ term that "adds" noise and we assume that it's normally distibuted for each value of X. So Y, for a given value of x, has a normal distribution. We'll expand more on this in the next post (or try at least). In other words, $$E(Y|X) = \mathcal{N(\mu=\alpha + B_1X_1, \sigma^2)}$$ or in matrix notation:  
  $$E(Y|X) = \mathcal{N(\mu=XB, \sigma^2I)}$$ where I is the identity matrix.
  . So, in this case, the link function is the normal distribution.

When the outcome can only take a value of 1 or 0, the normal distribution won't link the structural part of the model to the discrete part because the outcome is dichotomous - so a normal distribution won't do.  
  
  
But what if we want to link this outcome to a structural component in a linear way, like we did above? Welcome to link functions for the generalized linear model.

## Family of Exponential Distributions
This is where the bulk of the hard work will be. It turns out that probability density functions (pdf) like the normal distribution or discrete probability distributions (probability mass functions, or, pmf) like the binomial are of a family of distributions called the exponential family of distributions. In the case of the binomial, it is in the exponential family only when there are a fixed number of trials.

What's special about this is that members of this family can be written in the general form, 

\begin{equation}
\tag{A}

f_X(x|\theta) = h(x)exp[\eta(\theta)*T(x) - A(\theta)]
\end{equation}

For whatever reason, I like an equivalent form of this distribution a bit better:

\begin{equation}
\tag{B}

f(x, \theta, \phi) = exp[\frac{y\theta-b(\theta)}{a(\phi)} + c(y, \phi)] 
\end{equation}

Here, y is your outcome (or number of successes in the case of a binomial), \theta is a parameter, $b(\theta)$ is a function of \theta, $a(\phi)$ is a function of parameter \phi, and c() is a function or some set of functions of data and \phi. 

## The logit link and logistic regression

The binomial distribution looks like:

\begin{equation}
\tag{C}

f(y) = {n \choose y}p^y(1-p)^{n-y}
\end{equation}

This looks nothing like `equation B`.
Remember from `equation A,` above, that a `GLM` gives us the expectation of y given x. In linear regression, the expectation of y given an x value is simply, $\hat{y} = \alpha + B1_X1$  


A linear regression model won't work well, though, when we have a dichotomous outcome which simply can't be normally distributed given each value of `X` (aka, it can't have normally distributed errors). This will make more sense if we can link the structural portion of the model to a parameter of the binomial, which is, in the case of 1 trial, simply a bernoulli distribution with expecation, $p$, or, generally, with $n$ trials, $n*p$ where $p$ is the probability of success for a trial. In this way, we're saying our outcome is the result of bernoulli trials. Regardless, we have to transform to find the link function.

## Transforming the Binomial into Exponential Form
### Steps 1-4
1. The first step is taking the log of both sides of `equation C`, because, from **preliminary point 2**, this will take the multiplication and turn it into addition which we need to do to get closer to `B`.
2. Using **prelimiary point 4**, we factor and rearrange, and place the exponents in front of the log fuctions (for multiplication).
3. To get rid of the log on the left side, we exponentiate with $e$ both sides (using $exp(a)$ to mean $e^a$).
4. Re-write so f(y) back to normal. Proceed to step 5. The algebra is below. 

$$
\begin{equation}
\tag{1}
log(f(y)) = log({n\choose y})+ log(p)^y + log(1-p)^{n-y}
\end{equation}
$$

$$
\begin{equation}
\tag{2}
log(f(y)) = log({n\choose y})+ ylog(p) + (n-y)log(1-p) .
\end{equation}
$$

$$
\begin{equation}
\tag{3}
exp(log(f(y))) = exp[log({n\choose y})+ ylog(p) + (n-y)log(1-p)]
\end{equation}
$$
$$
\begin{equation}
\tag{4}
f(y) = exp[log({n\choose y})+ ylog(p) + (n-y)log(1-p)]
\end{equation}
$$

### Steps 5 - 7
To save on typing, we'll only write the term inside the `exp[ ]` term now.

5. We'll expand out $(n-y)(log(1-p))$ in step 5. 
6. Rewrite with step 5 expansion inserted back in. To make things simpler, we'll group our outcome, y, our parameter of interest p, and terms with the full data in it (n).
7. From **preliminary 3**, since first two terms have the same log base and multiplicative constant we can regroup such that $ylog(p) - ylog(1-p)$ becomes
$y[log(\frac{p}{1-p})]$.


\begin{equation}
\tag{5}
nlog(1-p) - ylog(1-p)
\end{equation}


\begin{equation}
\tag{6}
=ylog(p) - ylog(1-p) + nlog(1-p) + log({n\choose y})
\end{equation}
 

\begin{equation}
\tag{7}
=y[log(\frac{p}{1-p})] + nlog(1-p) + log{n\choose y}
\end{equation}


## Steps 8 - 10

This is starting to look just like we want, and if you've used logistic regression, there should be some familiar terms. 

Remember that our exponential form from equation 2:

\begin{equation}
\tag{B}

f(x, \theta, \phi) = exp[\frac{y\theta-b(\theta)}{a(\phi)} + c(y, \phi)] 
\end{equation}

It appears the $y\theta$ portion matches up with:   
$y[log(\frac{p}{1-p})]$


$$
\begin{equation}
\tag{8}
\theta = [log(\frac{p}{1-p})]
\end{equation}
$$

From equation 2, we see that the second term is also a function of theta, so we need to rewrite $nlog(1-p)$ in terms of \theta. So, the easiest way to do this is to solve for \theta in terms of p.

Exponentiate both sides of `8` then simply solve for \theta by:
A. multiplying both sides by $1-p$, expanding/multiplying out the left side, adding $exp(\theta)*p$ to both sides  
B. factoring out $p$, the common term from the right side, 
C. Divide both sides by (1+exp(\theta)  
D. $1 - p = \frac{1}{1 + exp(\theta)} = (1+exp(\theta))^{-1}$  



$$
\begin{equation}
\tag{9a}
exp(\theta) = \frac{p}{1-p} \\
exp(\theta)(1-p) = p \\
exp(\theta)-exp(\theta)*(p) = p \\
exp(\theta) = p + exp(\theta)*p \\
\end{equation}
$$


Factor:
$$
\begin{equation}
\tag{9b}
exp(\theta) = p(1 + exp(\theta)) \\
\end{equation}
$$


$$
\begin{equation}
\tag{9c}

\frac{exp(\theta)}{1+exp(\theta)} = p \\
1 = \frac{1 + exp(\theta)}{1+exp(\theta)} \\
\end{equation}
$$
$$
\begin{equation}
\tag{9d}

1 - p = \frac{1}{1 + exp(\theta)} \\ 
\end{equation}
$$

After that fair amount of algebra, let's rewrite 1 - p as $(1+exp(\theta))^{-1}$ because a negative exponent denotes a fraction.
This step is really important because of **prelimiary 4**. Thus, inputting   $nlog(1+exp(\theta))^{-1}$ back in -  

We can rewrite, now: \\ 

10a. Input $nlog(1+exp(\theta))^{-1}$ in place of  $nlog(1-p)$. \\  
10b. Input $-nlog(1+exp(\theta))$ because $log(a^4) = 4log(a)$  \\
$$
\begin{equation}
\tag{10a}
f(x, \theta, \phi)=y(\theta) + nlog(1+exp(\theta))^{-1} + log{n\choose y} \\
\end{equation}
$$
$$
\begin{equation}
\tag{10b}
f(x, \theta, \phi)=y(\theta) - nlog(1+exp(\theta)) + log{n\choose y}
\end{equation}
$$

Believe it or not, this is now in exponential form, where:

$$y(\theta) = ylog(\frac{p}{1-p})$$
$$b(\theta) = nlog(1+exp(\theta))$$
$$c(y, \phi) = log{n\choose y}$$
$$a(\phi)=1$$
$$f(x, \theta, \phi)=exp([y(\theta) - nlog(1+exp(\theta))] + log{n\choose y})$$

## Finding Expectations - a little bit of calculus (optional):
It turns out, that the expectation of a distribution in the exponential form is the first derivative of $b(\theta)$ and the variance is $a(\phi)$ times the second derivative of $b(\theta)$
1. $\mu = b'(\theta)$
2. $\sigma^2 = b''(\theta)*a(\phi)$

### Expectation/mean
$$
\begin{equation}
=b'(\theta) = n[log(1+exp(\theta))] \\
=n[exp(\theta)*\frac{1}{1+exp(\theta)}] \\
=n[\frac{exp(\theta)}{1+exp(\theta)}] \\
= n*p =np
\end{equation}
$$

This is great news. The first derivative worked out and we found the mean. This is what we need to pass through the link function, eventually.

### Variance (optional)
Given the definition above, this is how I solved. I use the chain and product rule instead of the quotient rule...sue me. 
$$
\begin{equation}
a(\phi)b''(\theta) = 1*n[\frac{exp(\theta)}{1+exp(\theta)}] \\ 
= n[exp({\theta})*(1+exp(\theta)^{-1})] + [exp(\theta)*-1*exp(\theta)*
(exp(1+\theta)^{-2})]] \\

=n[\frac{exp(\theta)}{{1+exp(theta)}} - \frac{exp(2\theta)}{(exp(1+\theta)^{2})}] \\
=n\frac{exp(\theta)}{1+exp(\theta)}(1-exp(\theta)) \\
=npq

\end{equation}
$$
If you know the mean of the binomial, you'll realize this isn't super important to go through all this work, but it's good to see. 

### Linking \mu and \theta
So the key aspect of a link function is how we go from \mu to \theta. That is,
$$ f(\mu) = \theta$$ is effectively the link function.



## Finding the link function
If you skipped the calculus portion, all we need to know now is \mu in terms of \theta

$$\mu = n*p = n*(\frac{exp(\theta)}{1+\exp(\theta)})$$
We need to solve for \theta. We'll start by multiplying both sides of the equation by $1+exp(\theta)$ and then follow the same process as `step 9` but replace `p` with $n*exp(\theta)$

$$
\begin{equation}
\mu(1+exp(\theta)) = n*exp(\theta) \\
\mu+(\mu*\exp(\theta)) = n*exp(\theta) \\
\mu = n*exp(\theta) - \mu*exp(\theta)  \\
\mu = exp(\theta)(n-\mu) \\ 
\frac{\mu}{n-\mu}=exp(\theta) \\
\log(\frac{\mu}{n-\mu}) = \theta
\end{equation}
$$
And that's your link function! But note, $\mu = n*p$ so we can rewrite it as:

$$\theta = log(\frac{n*p}{n-(n*p))})$$

Which, either factoring out n/n, or by substituting 1 for n as is the case for bernoulli trials like in scenarios we're used to with logistic regression:

$$\theta = log(\frac{1*p}{1-(1*p))})$$
$$\theta = log(\frac{p}{1-p})$$
And, now this looks awfully like logistic regression. 
