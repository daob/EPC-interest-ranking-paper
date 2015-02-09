# Using EPC-interest to evaluate measurement invariance in categorical data

## Abstract

Measurement invariance is necessary beceause without it the conclusions are wrong. EPC-interest evaluates how wrong directly, but only existed for continuous data. This paper extends EPC-interest to categorical data and discusses two example applications.

## Introduction

Examples of latent variable models with categorical data in social science:  the ideological positions of US senators, ..., and people's (post)materialism. 

Relating these variables to external variables is often of interest, for example to Party or year, to ..., and to country or country characteristics such as GDP. But if measurement differs over external variable values the relationship estimate of interest may be wrong. 

This is why people do measurement invariance testing (cites). Particularly, the common approach is to account for those violations of it that are present, partial measurement invariance (cites). 

As argued by Oberski (cites), presence is not so relevant but rather importance is, that is, whether measurement invariance affects the conclusions. Suggest to evaluate the robustness of the results of interest to measurmenet invariance assumptions using EPC-interest. EPC-interest estiamtes teh change in the parameter of interest when freeing a measurement invariance restriction. But only for continuous data. 

Here for categorical data like the data mentioned above. Need to account for dependencies between parameters to do with the same category. 


Next section,....


## Measurement invariance in categorical data

Latent variable model 
$$
	p(Y | x) = \int p(y | \xi) p(\xi | x)  d \xi
$$

Measurement part $p(y | \xi)$ structural part $p(\xi | x)$ and local independence 
$$
	p(y | \xi) = \prod_j p(y_j | \xi).
$$ 
For example, $y$ could be vote and $x$ Party and $\xi$ ideology. We often mostly want to known $p(\xi | x)$.

Now there is an assumption 
$$
	p(y | \xi) = p(y_j | \xi, x)
$$ 
which can often be parameterized using some kind of regression coefficient $\delta = 0$, "measurement invariance". The problem happens when $p(y | \xi) \neq p(y_j | \xi, x)$, so when $\delta \neq 0$. This is often called DIF (cites) or violation of measurement invariance. DIF is a problem because it means some of the effect of x on $\xi$ was due to a measurement difference. So $p(\xi | x)$ was wrong. Also, we can't just allow $p(y_j | \xi, x)$ for all $j$, that would not be identifiable.

Existing solutions:

* Test H0: $p(y | \xi) = p(y | \xi, x)$. Using chi-square or fit measure difference testing.
	* Disadvantage: what if H0 is rejected, which it usually is? 
* Partial invariance: Test separate H0's $p(y_j | \xi) = p(y_j | \xi, x)$. 
	* Disadvantage: does not account for the fact that importance w.r.t. $p(\xi | x)$ is not the same as size of the misspecification or significance 
* BSEM: put a strong prior centered on zero on all $\delta_j$. 
	* Good idea, needs more investigation. DIfficult to know in advance how strong the prior should be. In a sense this is the same problem as deciding on the $j$ to free.
* Alignment: similar to BSEM.


## Sensitivity analysis, directly or using EPC-interest

Same as earlier article but need intergration and to deal with dependencies.

* Advantage: evaluates directly what we want to knwo
* Disadvantage: not a property of a scale but fitness for purpose; assumes identifiability.
	

## Example 1

## Example 2

## Conclusion



 



##