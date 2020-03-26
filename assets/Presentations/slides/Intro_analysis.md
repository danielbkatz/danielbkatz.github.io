---
title: 'An Introduction to R: Data Cleaning, Wrangling, Visualizing, and Everything Else'
subtitle: 'Part 3'
author: "Daniel Katz"
output:
  xaringan::moon_reader:
    lib_dir: libs
    css: xaringan-themer.css
    nature:
      titleSlideClass: ["center", "middle", "my-title"]
      highlightStyle: agate
      highlightLines: true
      countIncrementalSlides: true



---

class: middle






## Tidy data principles
#### The notion of tidy data comes from Hadley Wickham, the author of the tidyverse
+ The philosophy of tidy data shapes the tidyverse

1. Each variable has its own column
2. Each observation has its own row
3. Each value has its own cell
--

Because...
1. Uniformity makes everything easier and you know how your data is stored
1. It makes vectorization easier

However, sometimes we need both tidy forms, and non-tidyforms of data 

---
Tidy (long data):
<table>
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> cases </th>
   <th style="text-align:right;"> population </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:right;"> 1999 </td>
   <td style="text-align:right;"> 745 </td>
   <td style="text-align:right;"> 1.999e+07 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:right;"> 2000 </td>
   <td style="text-align:right;"> 2666 </td>
   <td style="text-align:right;"> 2.060e+07 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Brazil </td>
   <td style="text-align:right;"> 1999 </td>
   <td style="text-align:right;"> 37737 </td>
   <td style="text-align:right;"> 1.720e+08 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Brazil </td>
   <td style="text-align:right;"> 2000 </td>
   <td style="text-align:right;"> 80488 </td>
   <td style="text-align:right;"> 1.745e+08 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> China </td>
   <td style="text-align:right;"> 1999 </td>
   <td style="text-align:right;"> 212258 </td>
   <td style="text-align:right;"> 1.273e+09 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> China </td>
   <td style="text-align:right;"> 2000 </td>
   <td style="text-align:right;"> 213766 </td>
   <td style="text-align:right;"> 1.280e+09 </td>
  </tr>
</tbody>
</table>

Not tidy (wide data):
<table>
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:right;"> 1999 </th>
   <th style="text-align:right;"> 2000 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:right;"> 745 </td>
   <td style="text-align:right;"> 2666 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Brazil </td>
   <td style="text-align:right;"> 37737 </td>
   <td style="text-align:right;"> 80488 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> China </td>
   <td style="text-align:right;"> 212258 </td>
   <td style="text-align:right;"> 213766 </td>
  </tr>
</tbody>
</table>
Years, here, are actually a value in their own right, thus values in a variable. Read more on the spread and gather functions, [here](https://r4ds.had.co.nz/tidy-data.html#spreading-and-gathering)

---
## Next functions go together, they're `group_by()` and `summarize()`

+ They do exactly what you think, but it's one of the more powerful tools in dplyr.

+ Let's use our `co16_rem` data.frame again


{% highlight r %}
names(co16_rem)
{% endhighlight %}



{% highlight text %}
##  [1] "CDS"                        "Name"                      
##  [3] "AggLevel"                   "DFC"                       
##  [5] "Subgroup"                   "Subgrouptype"              
##  [7] "NumCohort"                  "NumGraduates"              
##  [9] "Cohort Graduation Rate"     "NumDropouts"               
## [11] "Cohort Dropout Rate"        "NumSpecialEducation"       
## [13] "Special Ed Completers Rate" "NumStillEnrolled"          
## [15] "Still Enrolled Rate"        "NumGED"                    
## [17] "GED Rate"                   "Year"
{% endhighlight %}
---
## The details
+ `group_by()` groups data together by some factor (such as class participation)

+ `summarize()` performs some operation on the grouped data, using summary statistics. 

+ This is often useful for carrying out summary statistics-type analysis

---
## Let's get the average cohort size for males and females in a district


{% highlight r %}
mvf <- co16_rem %>% 
  select(CDS, DFC, AggLevel, Subgroup, Subgrouptype,
         NumCohort) %>% 
  filter(AggLevel=="D", 
         DFC=="N",
         Subgroup=="FEM"| Subgroup=="MAL",  
         Subgrouptype=="All") 

## Sorry, this gets a little long.
## Can create as many vars as you want in summarize()
mvf <-mvf %>% group_by(Subgroup) %>% #<<
      summarize(mean_co = mean(NumCohort, na.rm = T), #<< 
            se = sd(NumCohort, na.rm = T)) #<<
{% endhighlight %}
<table>
 <thead>
  <tr>
   <th style="text-align:left;"> Subgroup </th>
   <th style="text-align:right;"> mean_co </th>
   <th style="text-align:right;"> se </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> FEM </td>
   <td style="text-align:right;"> 471.3 </td>
   <td style="text-align:right;"> 961.3 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MAL </td>
   <td style="text-align:right;"> 491.7 </td>
   <td style="text-align:right;"> 1007.7 </td>
  </tr>
</tbody>
</table>

---

class: middle

## Challenge, `group_by()` and `summarize()`

1. Edit the code above so you're grouping by `Subgroup` AND `Subgrouptype` (feel free to use help). 

2. However, with Subgroup, filter it first to include Male, Female, and "All".

3. Something the state of CA always looks at: Group by Subgrouptype such that we keep only those classified by CA as  
  + "Hispanic or Latinx" (5) 
  + "African American" (6)
  + "White, not Hispanic (7), and "All".

3. With as an outcome, instead of NumCohort, use NumGraduates

---
class: middle

# Solution


{% highlight r %}
mvf <- co16_rem %>% 
  select(CDS, DFC, AggLevel, Subgroup, Subgrouptype,
         NumGraduates) %>% 
  filter(AggLevel=="D", 
         DFC=="N",
         Subgroup=="MAL"| 
           Subgroup=="FEM"|
           Subgroup=="All"|
         Subgrouptype==5|
           Subgrouptype==6|
           Subgrouptype==7) %>% 
  group_by(Subgroup, Subgrouptype) %>% #<<
  summarize(mean_grad = mean(NumGraduates, na.rm = T), 
            se = sd(NumGraduates, na.rm = T))
{% endhighlight %}
---
<table>
 <thead>
  <tr>
   <th style="text-align:left;"> Subgroup </th>
   <th style="text-align:left;"> Subgrouptype </th>
   <th style="text-align:right;"> mean_grad </th>
   <th style="text-align:right;"> se </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> All </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:right;"> 27.60 </td>
   <td style="text-align:right;"> 23.70 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> All </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 21.68 </td>
   <td style="text-align:right;"> 21.83 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> All </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 177.20 </td>
   <td style="text-align:right;"> 281.28 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> All </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:right;"> 25.23 </td>
   <td style="text-align:right;"> 21.12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> All </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:right;"> 75.91 </td>
   <td style="text-align:right;"> 111.06 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> All </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> 451.90 </td>
   <td style="text-align:right;"> 1139.34 </td>
  </tr>
</tbody>
</table>
---

{% highlight r %}
widemvf <- mvf %>% 
  gather(unit, numgrad, mean_grad:se) %>% 
  unite(temp1, Subgrouptype, unit, sep = ".") %>% 
  spread(temp1, numgrad)

head(widemvf) %>% 
  knitr::kable(format = "html")
{% endhighlight %}

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> Subgroup </th>
   <th style="text-align:right;"> 0.mean_grad </th>
   <th style="text-align:right;"> 0.se </th>
   <th style="text-align:right;"> 1.mean_grad </th>
   <th style="text-align:right;"> 1.se </th>
   <th style="text-align:right;"> 2.mean_grad </th>
   <th style="text-align:right;"> 2.se </th>
   <th style="text-align:right;"> 3.mean_grad </th>
   <th style="text-align:right;"> 3.se </th>
   <th style="text-align:right;"> 4.mean_grad </th>
   <th style="text-align:right;"> 4.se </th>
   <th style="text-align:right;"> 5.mean_grad </th>
   <th style="text-align:right;"> 5.se </th>
   <th style="text-align:right;"> 6.mean_grad </th>
   <th style="text-align:right;"> 6.se </th>
   <th style="text-align:right;"> 7.mean_grad </th>
   <th style="text-align:right;"> 7.se </th>
   <th style="text-align:right;"> 9.mean_grad </th>
   <th style="text-align:right;"> 9.se </th>
   <th style="text-align:right;"> All.mean_grad </th>
   <th style="text-align:right;"> All.se </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> All </td>
   <td style="text-align:right;"> 27.60 </td>
   <td style="text-align:right;"> 23.70 </td>
   <td style="text-align:right;"> 21.68 </td>
   <td style="text-align:right;"> 21.83 </td>
   <td style="text-align:right;"> 177.2 </td>
   <td style="text-align:right;"> 281.3 </td>
   <td style="text-align:right;"> 25.23 </td>
   <td style="text-align:right;"> 21.12 </td>
   <td style="text-align:right;"> 75.91 </td>
   <td style="text-align:right;"> 111.06 </td>
   <td style="text-align:right;"> 451.9 </td>
   <td style="text-align:right;"> 1139.3 </td>
   <td style="text-align:right;"> 102.60 </td>
   <td style="text-align:right;"> 197.0 </td>
   <td style="text-align:right;"> 255.0 </td>
   <td style="text-align:right;"> 354.5 </td>
   <td style="text-align:right;"> 50.22 </td>
   <td style="text-align:right;"> 51.38 </td>
   <td style="text-align:right;"> 824.9 </td>
   <td style="text-align:right;"> 1595.6 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> FEM </td>
   <td style="text-align:right;"> 25.80 </td>
   <td style="text-align:right;"> 12.72 </td>
   <td style="text-align:right;"> 23.13 </td>
   <td style="text-align:right;"> 17.07 </td>
   <td style="text-align:right;"> 101.9 </td>
   <td style="text-align:right;"> 147.8 </td>
   <td style="text-align:right;"> 21.26 </td>
   <td style="text-align:right;"> 13.06 </td>
   <td style="text-align:right;"> 46.50 </td>
   <td style="text-align:right;"> 58.73 </td>
   <td style="text-align:right;"> 257.6 </td>
   <td style="text-align:right;"> 622.9 </td>
   <td style="text-align:right;"> 67.14 </td>
   <td style="text-align:right;"> 115.2 </td>
   <td style="text-align:right;"> 145.6 </td>
   <td style="text-align:right;"> 184.6 </td>
   <td style="text-align:right;"> 34.07 </td>
   <td style="text-align:right;"> 28.40 </td>
   <td style="text-align:right;"> 443.6 </td>
   <td style="text-align:right;"> 840.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> MAL </td>
   <td style="text-align:right;"> 23.43 </td>
   <td style="text-align:right;"> 13.81 </td>
   <td style="text-align:right;"> 22.25 </td>
   <td style="text-align:right;"> 16.44 </td>
   <td style="text-align:right;"> 104.1 </td>
   <td style="text-align:right;"> 148.6 </td>
   <td style="text-align:right;"> 22.05 </td>
   <td style="text-align:right;"> 12.96 </td>
   <td style="text-align:right;"> 48.98 </td>
   <td style="text-align:right;"> 62.43 </td>
   <td style="text-align:right;"> 236.6 </td>
   <td style="text-align:right;"> 562.1 </td>
   <td style="text-align:right;"> 61.49 </td>
   <td style="text-align:right;"> 102.8 </td>
   <td style="text-align:right;"> 144.0 </td>
   <td style="text-align:right;"> 182.2 </td>
   <td style="text-align:right;"> 33.30 </td>
   <td style="text-align:right;"> 27.13 </td>
   <td style="text-align:right;"> 424.0 </td>
   <td style="text-align:right;"> 786.5 </td>
  </tr>
</tbody>
</table>
---
# What if I want to know frequencies?
 + Can just do the same as above but use `n()`
 

{% highlight r %}
freqtab <- co16 %>%
  group_by(Subgroup, Subgrouptype) %>%
  summarise (n = n()) %>%
  mutate(freq = n / sum(n))
{% endhighlight %}

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> Subgroup </th>
   <th style="text-align:left;"> Subgrouptype </th>
   <th style="text-align:right;"> n </th>
   <th style="text-align:right;"> freq </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> All </td>
   <td style="text-align:left;"> 0 </td>
   <td style="text-align:right;"> 740 </td>
   <td style="text-align:right;"> 0.0319 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> All </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 1730 </td>
   <td style="text-align:right;"> 0.0745 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> All </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 2249 </td>
   <td style="text-align:right;"> 0.0969 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> All </td>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:right;"> 1419 </td>
   <td style="text-align:right;"> 0.0611 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> All </td>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:right;"> 1830 </td>
   <td style="text-align:right;"> 0.0788 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> All </td>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> 3458 </td>
   <td style="text-align:right;"> 0.1489 </td>
  </tr>
</tbody>
</table>
---

class: middle, center

# Data VIZ with ggplot2

---
class: middle

## ggplot2

+ ggplot2 is a package built for visualizing all of our data. 

+ I might say we've done things a little backwards

+ Start with data visualization

+ the general form of ggplot is:
`ggplot(data, aes(mapping)) + geom_function(aes(mappings))`
---

class: middle 


### Building a ggplot


.pull-left[
1. Start with adding the data

1. Add an aesthetic internally or externally  

1. Add a geome (what kind of plot will it be?)   

1. Add other rules such as themes.  

1. Get help via documentation or other resources as you need]

--
.pull-right[
1. `ggplot(data)`

1. `ggplot(data =df, aes(x=x_var, y=y_var))` 

1. `ggplot(data=df, aes(x=x_var, y=y_var)) + geom_point(aes(color=grouo)) + geom_smooth(method=lm)`

1. `?ggplot2::geom_smooth`
]
---
class: middle, center

## Building a Plot

`ggplot(data=state16d, `
--
       `aes(x=droprate, y=GEDrate)) +`
--
         `geom_point()`
  

---
## Example



{% highlight r %}
ggplot(data=state16d, 
       aes(x=droprate, y=GEDrate)) + 
         geom_point(aes(color=Subgroup)) +
         geom_smooth(method = lm) 
{% endhighlight %}

<img src="/figure/./assets/Presentations/slides/Intro_analysis/unnamed-chunk-12-1.png" title="plot of chunk unnamed-chunk-12" alt="plot of chunk unnamed-chunk-12" style="display: block; margin: auto;" />

---
## Logic of ggplot2
+ "An aesthetic is a visual property of the objects in your plot. Aesthetics include things like the size, the shape, or the color of your points."
  - Garrett Grolemund & Hadley Wickham in [R for Data Science](https://r4ds.had.co.nz/data-visualisation.html#aesthetic-mappings)

+ We have to make some decisions about how aesthetics should be mapped to your data. 

+ What do we want our data to look like?

+ For instance, the x-axis aesthetic in the plot previously, was mapped to `Cohort Dropout Rate` and the color was mapped to `subgroup`

+ Other aesthetics include size and shape

+ It's important to know the `class` of your variables
---

# Another example
Just a histogram? (only one axis!)


{% highlight r %}
ggplot(data=state16d, 
       aes(x=NumCohort)) + 
  geom_histogram()
{% endhighlight %}

![plot of chunk unnamed-chunk-13](/figure/./assets/Presentations/slides/Intro_analysis/unnamed-chunk-13-1.png)


---
## Warmup


{% highlight r %}
plot1 <- ggplot(data=state16d, 
                aes(x=droprate, y=GEDrate)) + 
         geom_point(aes(color=Subgroup))
{% endhighlight %}

1. What variables in state16d are categorical? Continuous? (hint, there's one command)

1. Using the code above, map a continuous variable to <mark>color</mark>, <mark>size</mark>, and <mark>shape</mark> (using geom_point). How do these aesthetics behave differently for categorical vs. continuous variables?

1. Use ?geom_point to find out what the `stroke` aesthetic does

1. instead of `color=Subgroup` above, use `color=GEDrate >.3`

1. What are three other `geom_functions`?

 * These questions are modified versions of the ones found in _R for Data Science_
---


{% highlight r %}
plot1 <- ggplot(data=state16d, 
                aes(x=droprate, y=GEDrate)) + 
         geom_point(aes(color=GEDrate >.3))
{% endhighlight %}

---
# Challenge: Aesthetics
+ In California, Charter Schools are often continuation schools.

+ Much of the charter school debate doesn't really look at continuation schools, but they're not identified in our data

Using ggplot2, answer the questions:

+ Is there a relationship between the size of a school (NumCohort) and the grad rate (`Cohort Graduation Rate`)?

+ Does this relationship look different for charters and non-charter schools?

+ How might we visualize?

**Hint, The code for school level data for AggLevel = "S", Use subgroup and subgrouptype ="All", start with co16_rem and filter**

---

{% highlight r %}
# first, filter the data
graphdata2 <- state16 %>% 
  filter(AggLevel=="S", 
         Subgroup=="All", 
         Subgrouptype=="All")

# plot the data
plot2 <- ggplot(graphdata2, 
            aes(NumCohort, `Cohort Graduation Rate`))+
  geom_point(aes(color=DFC)) 
{% endhighlight %}

---
## We can also do this with pipes all the way through

{% highlight r %}
plot2 <- state16 %>% 
  filter(AggLevel=="S", 
         Subgroup=="All", 
         Subgrouptype=="All") %>%
  ggplot(aes(x=NumCohort, y=gradrate))+
  geom_point(aes(color=DFC)) 

plot2
{% endhighlight %}

<img src="/figure/./assets/Presentations/slides/Intro_analysis/unnamed-chunk-17-1.png" title="plot of chunk unnamed-chunk-17" alt="plot of chunk unnamed-chunk-17" style="display: block; margin: auto;" />

---

class: middle

## Using facets

+ Can we looked at the distributions of cohort sizes by non-charters and charters?

+ Can we answer the questions from the previous slides *within* charters and non-charters?

+ Absolutely, with facet_wrap

---


{% highlight r %}
plot3 <- ggplot(graphdata2, 
            aes(NumCohort))+
  geom_histogram() + facet_wrap(~DFC)

plot3
{% endhighlight %}

<img src="/figure/./assets/Presentations/slides/Intro_analysis/unnamed-chunk-18-1.png" title="plot of chunk unnamed-chunk-18" alt="plot of chunk unnamed-chunk-18" height="40%" />

---
# Challenge: Facets
+ Facets use `~` which denotes a `formula.`

+ A formula is simply another data-structure in R. Don't worry about that, for now. 

+ You can have two sides to the formula. To see this, run the code:

{% highlight r %}
graphdata3 <- state16 %>% 
  filter(AggLevel=="S", 
         Subgroup=="MAL"| Subgroup=="FEM", 
         Subgrouptype=="All")

plot4 <- ggplot(graphdata3, 
            aes(NumDropouts))+
  geom_histogram() + facet_wrap(~Subgroup, nrow=1)

#vs 

plot5 <- ggplot(graphdata3, 
            aes(NumDropouts))+
  geom_histogram() + facet_wrap(DFC~Subgroup)
{% endhighlight %}
---
# Plot 4

{% highlight r %}
plot4
{% endhighlight %}

<img src="/figure/./assets/Presentations/slides/Intro_analysis/unnamed-chunk-20-1.png" title="plot of chunk unnamed-chunk-20" alt="plot of chunk unnamed-chunk-20" style="display: block; margin: auto;" />

---
# Plot 5

{% highlight r %}
plot5
{% endhighlight %}

<img src="/figure/./assets/Presentations/slides/Intro_analysis/unnamed-chunk-21-1.png" title="plot of chunk unnamed-chunk-21" alt="plot of chunk unnamed-chunk-21" style="display: block; margin: auto;" />
---
class: middle
# What happens when you replace facet_wrap with facet_grid?

--

{% highlight r %}
plot6 <- ggplot(graphdata3, 
            aes(NumDropouts))+
  geom_histogram() + 
  facet_grid(DFC~Subgroup)
{% endhighlight %}
---

{% highlight r %}
plot6
{% endhighlight %}

![plot of chunk unnamed-chunk-23](/figure/./assets/Presentations/slides/Intro_analysis/unnamed-chunk-23-1.png)

---
class: middle 

## More on `geom_`
+ According to Hadley Wickham, author of ggplot2, `geom_s` are so-called because they represent the geometric objects that we use to represent data

+ Boxplots use <mark>box geoms</mark>, line charts use <mark>line geoms</mark>, scatter plots use...

--
  + Point geoms
  
--
  
+ We can represent the same data in multiple ways using geoms_

--

+ we've already played with geoms above, to get a sense.

--

+ Because of code completion, with `geom_ ` in a function, we can see our options.
---

## Geoms continued

+ we can add aesthetics just to that `geom_function`

{% highlight r %}
plot7 <- ggplot(graphdata3, 
            aes(x=NumDropouts, y = gradrate))+
  geom_point(aes(color=Subgroup))

plot7
{% endhighlight %}

<img src="/figure/./assets/Presentations/slides/Intro_analysis/unnamed-chunk-24-1.png" title="plot of chunk unnamed-chunk-24" alt="plot of chunk unnamed-chunk-24" style="display: block; margin: auto;" />

---

class: middle

## Challenge (geoms)

1. Make a boxplot starting with `state16` data creating `graphdata4` by
  1.  filtering so `subgrouptype` = "All"
  1. `Subgroup` = "MAL", "FEM" and "All"
  1. looking at the difference between graduation rates (gradrates) for charters and non-charters, but just

2. Add a group to the boxplot such that you look at differences between charters and non-charters and the subgroups (using `Subgroup`) within each

--
1. Start with: 

{% highlight r %}
graphdata4 <- state16 %>% 
  filter(Subgroup=="MAL"| Subgroup=="FEM"|Subgroup=="All", 
         Subgrouptype=="All")
{% endhighlight %}

---
## Solutions


{% highlight r %}
#bar chart
ggplot(graphdata4) + 
  geom_boxplot(aes(y = gradrate, x = DFC,
                   fill="red")) #<<
{% endhighlight %}

<img src="/figure/./assets/Presentations/slides/Intro_analysis/unnamed-chunk-26-1.png" title="plot of chunk unnamed-chunk-26" alt="plot of chunk unnamed-chunk-26" style="display: block; margin: auto;" />

---


{% highlight r %}
#bar chart
ggplot(graphdata4, 
       aes(y = gradrate, x = DFC, fill = Subgroup)) +
       geom_boxplot() #<<
{% endhighlight %}

<img src="/figure/./assets/Presentations/slides/Intro_analysis/unnamed-chunk-27-1.png" title="plot of chunk unnamed-chunk-27" alt="plot of chunk unnamed-chunk-27" style="display: block; margin: auto;" />

---

class: middle 

## All the geoms
There are a lot of geoms_

See the most popular geoms, [_**here**_](https://eric.netlify.com/2017/08/10/most-popular-ggplot2-geoms/)


---
## Starting to think about descriptives, putting it together

+ Faceting is super useful when you want to look at correlations by group. Go back to `graphdata4`


{% highlight r %}
plotcorr <- ggplot(graphdata4, 
            aes(x=droprate, y = gradrate))+
  geom_point(aes(color=Subgroup)) + 
  facet_grid(Subgroup~DFC) 
{% endhighlight %}
---

{% highlight r %}
plotcorr
{% endhighlight %}

<img src="/figure/./assets/Presentations/slides/Intro_analysis/unnamed-chunk-29-1.png" title="plot of chunk unnamed-chunk-29" alt="plot of chunk unnamed-chunk-29" style="display: block; margin: auto;" />

---
## ggplot2 Labels

+ ggplot2 objects can be always added to with a `+`

+ What we'll add is `labs()`


{% highlight r %}
plotcorr <- plotcorr + 
  labs(y="Cohort Graduation Rate", #<<
  x= "Cohort Dropout Rate", 
  title = "Relationship between hs grad rates and dropout rates")

plotcorr
{% endhighlight %}

<img src="/figure/./assets/Presentations/slides/Intro_analysis/unnamed-chunk-30-1.png" title="plot of chunk unnamed-chunk-30" alt="plot of chunk unnamed-chunk-30" style="display: block; margin: auto;" />
---

class: middle

### Challenge: Using labs, 

1. Add a subtitle to the plot 
1. Change the order of the facet/rearrange the facet using facet_grid(x~y)
---
#solution (labs)


{% highlight r %}
plotcorr <- ggplot(graphdata4, 
            aes(x=droprate, y = gradrate))+
  geom_point(aes(color=Subgroup)) + 
  facet_grid(DFC~Subgroup) +
  labs(y="Cohort Graduation Rate", #<<
  x= "Cohort Dropout Rate", 
  title = "Relationship between hs grad rates and dropout rates",
  subtitle = "As faceted by CA subgroup and charter status")

plotcorr
{% endhighlight %}

<img src="/figure/./assets/Presentations/slides/Intro_analysis/unnamed-chunk-31-1.png" title="plot of chunk unnamed-chunk-31" alt="plot of chunk unnamed-chunk-31" style="display: block; margin: auto;" />
---
## What about changing the legened?
This is a good resource for more on [_**ggplot text**_](http://r-statistics.co/Complete-Ggplot2-Tutorial-Part2-Customizing-Theme-With-R-Code.html): 

{% highlight r %}
plotcorr <- plotcorr +  
  scale_color_discrete(labels = c("All", "Female", "Male"))
plotcorr
{% endhighlight %}

<img src="/figure/./assets/Presentations/slides/Intro_analysis/unnamed-chunk-32-1.png" title="plot of chunk unnamed-chunk-32" alt="plot of chunk unnamed-chunk-32" style="display: block; margin: auto;" />

---
## Labelling individual Cases (with GEDrates greater than 20%)
See package, [_**ggrepl**_](https://cran.r-project.org/web/packages/ggrepel/vignettes/ggrepel.html) to make this cleaner


{% highlight r %}
plotlab <- plot1 +  geom_text(data=subset(graphdata4, GEDrate >30), 
          aes(x=droprate, y = GEDrate, label=Name))
          
plotlab
{% endhighlight %}

<img src="/figure/./assets/Presentations/slides/Intro_analysis/unnamed-chunk-33-1.png" title="plot of chunk unnamed-chunk-33" alt="plot of chunk unnamed-chunk-33" style="display: block; margin: auto;" />
---
# There's much, much, much more:

+ Check out themes related to ggplot2

+ Check out how to make plots APA or the like, compliant here: [_**APA**_](https://ndphillips.github.io/IntroductionR_Course/assignments/wpa/wpa_5.html)

+ A good startin place, as usual, is the ggplot2 R studio [_**page**_](https://ggplot2.tidyverse.org/)  

---
# Exporting data/saving data

+ To export data from R is quite simple, but remember our directories! 

<img src="/directory.jpg" title="plot of chunk unnamed-chunk-34" alt="plot of chunk unnamed-chunk-34" width="90%" style="display: block; margin: auto;" />

+ We want to put any data we've cleaned in a folder called something like, "cleaneddata" and give it a name so we know what's in there. 
---

class: middle

+ Remember `state16d`?

+ We'll use the `write_csv()` function from the `readr` package. 

+ general form (`write_csv(df, "folder/data.csv1"`) - extension can be anything related to `write_*` start typing `write_` to see what happens...

+ What you save it as (in quotes) doesn't have to be the same as what it's called in R.


{% highlight r %}
write_csv(state16d, "Cleandata/districtsub.csv")

# to write to SPSS
library(haven)
write_sav(state16d, "Cleandata/districtsub.sav")

# sav is an SPSS file extension
{% endhighlight %}
---

class: middle

# Exporting ggplot2 object


{% highlight r %}
ggsave("plot1.pdf", plot1)

ggsave("plot1.png", plot1)

# make it a certain size
ggsave("plot1.png", width = 20, height = 20, units = "cm")
{% endhighlight %}
---

class: middle
# Challenge: Exporting

1. Export one dataframe you made, either in csv or SPSS file format to a "wrangledata" subdirectory in your working directory

1. Export one plot you made to a folder called `plots` in your working directory.

---

class: middle

# Part 3.2: Descriptive statistics
+ One of the best asepcts of R is that there are a lot of ways to do the same thing. 

--
+ This is also one of the worst aspects of R

+ We've already seen a few ways to get descriptive statistics just brute forcing it with dplyr.

---

class: middle

#### Workflow: Explore, Visualize, Describe, Model 

<img src="/datasciexp.png" title="plot of chunk unnamed-chunk-37" alt="plot of chunk unnamed-chunk-37" style="display: block; margin: auto;" />
---
## An easy way to get descriptives
+ Remember `summary()`

+ What happens when you run `summary()` on all of state16d?

+ What happens when you run `summary()` on just one column?


{% highlight r %}
summary(state16d)
{% endhighlight %}



{% highlight text %}
##      CDS                Name             AggLevel             DFC           
##  Length:493         Length:493         Length:493         Length:493        
##  Class :character   Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character   Mode  :character  
##                                                                             
##                                                                             
##                                                                             
##                                                                             
##    Subgroup         Subgrouptype         NumCohort      NumGraduates  
##  Length:493         Length:493         Min.   :   11   Min.   :   11  
##  Class :character   Class :character   1st Qu.:  134   1st Qu.:  119  
##  Mode  :character   Mode  :character   Median :  372   Median :  336  
##                                        Mean   :  922   Mean   :  825  
##                                        3rd Qu.: 1109   3rd Qu.: 1021  
##                                        Max.   :34472   Max.   :26654  
##                                        NA's   :19      NA's   :32     
##   NumDropouts      gradrate        droprate       GEDrate      
##  Min.   :  11   Min.   :  0.0   Min.   : 0.0   Min.   : 0.000  
##  1st Qu.:  25   1st Qu.: 84.2   1st Qu.: 2.9   1st Qu.: 0.000  
##  Median :  49   Median : 90.9   Median : 5.5   Median : 0.000  
##  Mean   : 107   Mean   : 83.4   Mean   :10.2   Mean   : 0.208  
##  3rd Qu.: 115   3rd Qu.: 94.8   3rd Qu.:10.0   3rd Qu.: 0.000  
##  Max.   :4738   Max.   :100.0   Max.   :81.1   Max.   :15.700  
##  NA's   :184
{% endhighlight %}



{% highlight r %}
summary(state16d$NumGraduates)
{% endhighlight %}



{% highlight text %}
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##      11     119     336     825    1021   26654      32
{% endhighlight %}

+ Both give us NAs, which is convenient

+ Can also build from scratch using xtable

+ But hard to export (I still use these to get a quick understanding)
---

## I personally like the Startgazer package

+ `Stargazer` will give you descriptive statistics that are outputtable

+ `Stargazer` will output to various styles (problematically, no apa style option, though, but close enough)

+ `Stargazer` will format your regression output (as we'll see)

+ For writing in word
  + I recommend html output
  because you can open it with Excel and edit or open in webbrowser and copy-paste into spreadsheet
  + Can also output to Latex

+ Stargazer takes as argument the data (or the data subset), the way to output the data, and many others (see ?Stargazer)

+ The challenge with stargazer is that you need to make sure the dataframe is of class, data.frame (you have to coerce it, see below) 

---
## Example 

{% highlight r %}
library(stargazer)

# Need to select only numeric vars
numdist <- state16d %>% 
  select(NumCohort:GEDrate) %>% 
  as.data.frame(.)

stargazer(numdist, type="html", 
          out = "describe.html", 
          digits = 2)
{% endhighlight %}



{% highlight text %}
## 
## <table style="text-align:center"><tr><td colspan="8" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Statistic</td><td>N</td><td>Mean</td><td>St. Dev.</td><td>Min</td><td>Pctl(25)</td><td>Pctl(75)</td><td>Max</td></tr>
## <tr><td colspan="8" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">NumCohort</td><td>474</td><td>922.10</td><td>1,935.00</td><td>11.00</td><td>134.00</td><td>1,109.00</td><td>34,472.00</td></tr>
## <tr><td style="text-align:left">NumGraduates</td><td>461</td><td>824.90</td><td>1,596.00</td><td>11.00</td><td>119.00</td><td>1,021.00</td><td>26,654.00</td></tr>
## <tr><td style="text-align:left">NumDropouts</td><td>309</td><td>106.70</td><td>289.40</td><td>11.00</td><td>25.00</td><td>115.00</td><td>4,738.00</td></tr>
## <tr><td style="text-align:left">gradrate</td><td>493</td><td>83.38</td><td>21.52</td><td>0.00</td><td>84.21</td><td>94.81</td><td>100.00</td></tr>
## <tr><td style="text-align:left">droprate</td><td>493</td><td>10.21</td><td>14.06</td><td>0.00</td><td>2.90</td><td>10.00</td><td>81.10</td></tr>
## <tr><td style="text-align:left">GEDrate</td><td>493</td><td>0.21</td><td>1.19</td><td>0.00</td><td>0.00</td><td>0.00</td><td>15.70</td></tr>
## <tr><td colspan="8" style="border-bottom: 1px solid black"></td></tr></table>
{% endhighlight %}
---

class: middle

## Challenge, descriptive statistics

1.  Using stargazer documentation, change the "type" argument so that it outputs in a way that you can understand the output either in the console or the viewer.

2. Using stargazer documentation, change the table "title."

3. How can you use the `flip` argument?

---
## Solutions

{% highlight r %}
stargazer(numdist, type="text", 
          digits = 2, 
          title = "Danny's Descriptive Statistics")
{% endhighlight %}



{% highlight text %}
## 
## Danny's Descriptive Statistics
## ==================================================================
## Statistic     N   Mean  St. Dev.  Min  Pctl(25) Pctl(75)    Max   
## ------------------------------------------------------------------
## NumCohort    474 922.10 1,935.00 11.00  134.00  1,109.00 34,472.00
## NumGraduates 461 824.90 1,596.00 11.00  119.00  1,021.00 26,654.00
## NumDropouts  309 106.70  289.40  11.00  25.00    115.00  4,738.00 
## gradrate     493 83.38   21.52   0.00   84.21    94.81    100.00  
## droprate     493 10.21   14.06   0.00    2.90    10.00     81.10  
## GEDrate      493  0.21    1.19   0.00    0.00     0.00     15.70  
## ------------------------------------------------------------------
{% endhighlight %}


{% highlight r %}
stargazer(numdist, type="text", 
          digits = 2, 
          title = "Danny's Descriptive Statistics",
          flip = T)
{% endhighlight %}

---

class: middle

#Describeby, with `psych`

+ Another useful descriptive statistics package is `psych` which also has a lot of other useful tools including, various psychometric-type analysis functions

+ It provides descriptive statistics by a certain grouping variable\

+ Run the code below and also replace `mat=T` with `mat=F`

+ What happens?

---


{% highlight r %}
library(psych)

numdist2 <- state16 %>%
  select(DFC, 
         Subgroup, 
         Subgrouptype, 
         NumCohort:GEDrate) 
    
numdist2 <- numdist2 %>% 
  filter(Subgroup=="All"|Subgrouptype=="All")%>%
  as.data.frame(.) %>% 
  select(-Subgroup, -Subgrouptype) 


# This is the actual psych package code
descriptab <- describeBy(numdist2, 
                          group = numdist2$DFC, 
                          na.rm=T, 
                         digits = 2)
{% endhighlight %}

---

Class: middle

## Aside, lists...

+ We haven't touched lists, but many packages will output in list form

+ That is, it'll give you a `list` of output. 

+ In the `Global Environment`, if you click on the blue arrow next to a list, it'll show you the list elements. 

+ You can also use `str(list_name)`

---

Class: middle

# Examples

+ A list can contain other data structures.

+ What does `descriptab$Y` do? What about `descrptab[[1]]`?
--

{% highlight r %}
str(descriptab)
descriptab$Y
descriptab[[1]]
{% endhighlight %}

+ You can view package output by viewing the documentation (output is described in `Values` section of documentation)

+ You can access package output by using
  + `object$name` like above, 
  + or `object[[1]]` where the 1 is replaced with the desired position and double brackets represents position in the list.

+ No shortcut, here, just have to read the documentation

---

Class: middle

# Wrapping up descriptives

+ For nice correlation output, please check out the `apaTables` package

+ For quick output, check Hmisc

+ Don't forget the tidyverse! 

+ An overview of the descriptive statistics methods [_**here**_](https://dabblingwithdata.wordpress.com/2018/01/02/my-favourite-r-package-for-summarising-data/)

---
class: middle

## Some basic linear models

+ The basic linear models from R, require no external packages.

+ R was built for statistics!

We'll look at two main statistical tools, today...

+ `t.test` and `lm()` (anything else you all want to see?)

+ Other options include paired sample t.test, different alternative hypotheses

---
Class: middle

## `t tests`
+ t-tests in R are run simply by using `t.test()`

+ `?t.test`, you'll want "stats::t.test"

+ R assumes, unequal variances of the two groups, thus uses Welch's test

+ However, this is just a little more stringent. To override, use, `var.equal=T`

+ If your two factors are in two different columns, you might need to name them (remember tidydata is easier)
---
# Example run code, below:

{% highlight r %}
# this creates fictional data
NYCtestscore <- rnorm(1000, mean = 2, sd=1)
LAtestscore <- rnorm(1000, mean = 3, sd=1)
testscores <- cbind(NYCtestscore, LAtestscore)
head(testscores)
{% endhighlight %}



{% highlight text %}
##      NYCtestscore LAtestscore
## [1,]      0.08251       2.228
## [2,]      3.47400       2.953
## [3,]      2.62029       2.452
## [4,]      1.25411       3.919
## [5,]      2.70657       2.347
## [6,]      2.68009       2.417
{% endhighlight %}


{% highlight r %}
# two group
mod1 <- t.test(NYCtestscore, LAtestscore)
{% endhighlight %}

---
class: middle

{% highlight r %}
mod1
{% endhighlight %}



{% highlight text %}
## 
## 	Welch Two Sample t-test
## 
## data:  NYCtestscore and LAtestscore
## t = -23, df = 2000, p-value <2e-16
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -1.1549 -0.9767
## sample estimates:
## mean of x mean of y 
##     1.975     3.041
{% endhighlight %}
---

class: middle


## Easier, using a formula,, but only applicable using two-sample test
+ If your factor is in one column (such as charter/not charter in DFC)

+ Takes the form `t.test(state16, Outcome~Factor)`

+ Try doing this with `state16`, using gradrate and DFC

+ You can access different parts of the t.test if you use `mod2$*`
---
## The Broom Package
+ Also, check out the `broom` package and the function `tidy`



{% highlight r %}
library(broom)
mod2 <- t.test(data=state16, gradrate~DFC)

tidy(mod2)
{% endhighlight %}



{% highlight text %}
## # A tibble: 1 x 10
##   estimate estimate1 estimate2 statistic   p.value parameter conf.low conf.high
##      <dbl>     <dbl>     <dbl>     <dbl>     <dbl>     <dbl>    <dbl>     <dbl>
## 1     10.2      75.7      65.5      30.1 6.66e-195    19784.     9.56      10.9
## # ... with 2 more variables: method <chr>, alternative <chr>
{% endhighlight %}


---

class: middle 
## Linear regression
+ The form is `lm(outcome ~ covariate1 + covariat2...)`
  + Where lm() is the regression function

+ You can use stargazer to output nice tables

+ You can easily check assumptions, visually

+ You don't need to dummy out categorical variables as long as they're factors (or, at least, character)

+ You can interact variables within the equation with `*`, 

`lm(outcome ~ covariate1 + covariate2 + covariate1* covariat2)` 

or `:` 

`lm(outcome ~ covariate1 + covariate2 + covariate1: covariat2)`
---
# Linear Regression
$\widehat{gradraterate} = \alpha + \beta_1DFC$


{% highlight r %}
# Example usage
modlm1 <- lm(data = state16, gradrate~DFC)
summary(modlm1)
{% endhighlight %}



{% highlight text %}
## 
## Call:
## lm(formula = gradrate ~ DFC, data = state16)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -75.7  -15.7   16.3   24.3   34.5 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   75.703      0.137   552.2   <2e-16 ***
## DFCY         -10.229      0.315   -32.5   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 33.9 on 75260 degrees of freedom
## Multiple R-squared:  0.0138,	Adjusted R-squared:  0.0138 
## F-statistic: 1.05e+03 on 1 and 75260 DF,  p-value: <2e-16
{% endhighlight %}
---
# It's easy to check assumptions

{% highlight r %}
# to check assumptions
plot(modlm1)
{% endhighlight %}

![plot of chunk unnamed-chunk-49](/figure/./assets/Presentations/slides/Intro_analysis/unnamed-chunk-49-1.png)![plot of chunk unnamed-chunk-49](/figure/./assets/Presentations/slides/Intro_analysis/unnamed-chunk-49-2.png)![plot of chunk unnamed-chunk-49](/figure/./assets/Presentations/slides/Intro_analysis/unnamed-chunk-49-3.png)![plot of chunk unnamed-chunk-49](/figure/./assets/Presentations/slides/Intro_analysis/unnamed-chunk-49-4.png)

---
class: middle

# Challenge

1.  Run a regression in which you regress GEDrate on droprate and DFC using state16 data:

  + filter subgrouptype="All"
  + filter AggLevel!="T"
  
.center[$\widehat{GEDrate} = \alpha +\beta_1droprate + \beta_2DFC$]
  

1. Regress GEDrate on droprate as well as the interaction term between DFC and Subgroup 
$\widehat{GEDrate} = \alpha + \beta_1droprate + \beta_2DFC + \beta_3DFC*Subgroup$


1. Interpret results (roughly)
---

{% highlight r %}
state16_2 <- state16 %>%
  filter(Subgrouptype=="All",
         AggLevel!="T")  
  

mod3 <- lm(data=state16_2, GEDrate~droprate + DFC)
mod4 <- lm(data=state16_2, GEDrate~droprate + DFC*Subgroup)
{% endhighlight %}

---
# Ugly...

{% highlight r %}
summary(mod3)
{% endhighlight %}



{% highlight text %}
## 
## Call:
## lm(formula = GEDrate ~ droprate + DFC, data = state16_2)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -0.42  -0.20  -0.16  -0.15  99.85 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  0.146069   0.016620    8.79  < 2e-16 ***
## droprate     0.002704   0.000544    4.97  6.6e-07 ***
## DFCY        -0.045814   0.031344   -1.46     0.14    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1.87 on 22236 degrees of freedom
## Multiple R-squared:  0.00118,	Adjusted R-squared:  0.00109 
## F-statistic: 13.2 on 2 and 22236 DF,  p-value: 1.9e-06
{% endhighlight %}



{% highlight r %}
summary(mod4)
{% endhighlight %}



{% highlight text %}
## 
## Call:
## lm(formula = GEDrate ~ droprate + DFC * Subgroup, data = state16_2)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -0.50  -0.23  -0.18  -0.10  99.85 
## 
## Coefficients:
##                   Estimate Std. Error t value Pr(>|t|)    
## (Intercept)       0.179364   0.035746    5.02  5.3e-07 ***
## droprate          0.002694   0.000545    4.95  7.7e-07 ***
## DFCY             -0.058728   0.077178   -0.76   0.4467    
## SubgroupEL       -0.025784   0.050769   -0.51   0.6116    
## SubgroupFEM      -0.085756   0.049654   -1.73   0.0842 .  
## SubgroupMAL       0.051501   0.049209    1.05   0.2953    
## SubgroupMIG      -0.183439   0.064598   -2.84   0.0045 ** 
## SubgroupSD        0.011443   0.049231    0.23   0.8162    
## SubgroupSE       -0.091858   0.049647   -1.85   0.0643 .  
## DFCY:SubgroupEL  -0.075045   0.112879   -0.66   0.5062    
## DFCY:SubgroupFEM  0.040853   0.109617    0.37   0.7094    
## DFCY:SubgroupMAL  0.000551   0.109421    0.01   0.9960    
## DFCY:SubgroupMIG -0.008474   0.162364   -0.05   0.9584    
## DFCY:SubgroupSD  -0.035058   0.109251   -0.32   0.7483    
## DFCY:SubgroupSE   0.130115   0.111226    1.17   0.2421    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1.87 on 22224 degrees of freedom
## Multiple R-squared:  0.00234,	Adjusted R-squared:  0.00171 
## F-statistic: 3.73 on 14 and 22224 DF,  p-value: 2.65e-06
{% endhighlight %}
---
# Better!

{% highlight r %}
stargazer(mod3, mod4, type = "text", out = "modcompare.html")
{% endhighlight %}



{% highlight text %}
## 
## =======================================================================
##                                     Dependent variable:                
##                     ---------------------------------------------------
##                                           GEDrate                      
##                                (1)                       (2)           
## -----------------------------------------------------------------------
## droprate                    0.003***                  0.003***         
##                              (0.001)                   (0.001)         
##                                                                        
## DFCY                         -0.046                    -0.059          
##                              (0.031)                   (0.077)         
##                                                                        
## SubgroupEL                                             -0.026          
##                                                        (0.051)         
##                                                                        
## SubgroupFEM                                            -0.086*         
##                                                        (0.050)         
##                                                                        
## SubgroupMAL                                             0.052          
##                                                        (0.049)         
##                                                                        
## SubgroupMIG                                           -0.183***        
##                                                        (0.065)         
##                                                                        
## SubgroupSD                                              0.011          
##                                                        (0.049)         
##                                                                        
## SubgroupSE                                             -0.092*         
##                                                        (0.050)         
##                                                                        
## DFCY:SubgroupEL                                        -0.075          
##                                                        (0.113)         
##                                                                        
## DFCY:SubgroupFEM                                        0.041          
##                                                        (0.110)         
##                                                                        
## DFCY:SubgroupMAL                                        0.001          
##                                                        (0.109)         
##                                                                        
## DFCY:SubgroupMIG                                       -0.008          
##                                                        (0.162)         
##                                                                        
## DFCY:SubgroupSD                                        -0.035          
##                                                        (0.109)         
##                                                                        
## DFCY:SubgroupSE                                         0.130          
##                                                        (0.111)         
##                                                                        
## Constant                    0.146***                  0.179***         
##                              (0.017)                   (0.036)         
##                                                                        
## -----------------------------------------------------------------------
## Observations                 22,239                    22,239          
## R2                            0.001                     0.002          
## Adjusted R2                   0.001                     0.002          
## Residual Std. Error    1.866 (df = 22236)        1.866 (df = 22224)    
## F Statistic         13.180*** (df = 2; 22236) 3.729*** (df = 14; 22224)
## =======================================================================
## Note:                                       *p<0.1; **p<0.05; ***p<0.01
{% endhighlight %}

---
# Challenge:
**Try to plot mod3 in ggplot2**
--
Careful in interpretation (make a scatter plot or add points if you'd like)

{% highlight r %}
ggplot(data=state16_2, 
        aes(x=droprate, y=GEDrate, color=DFC)) +
  geom_smooth(method = lm) +
  labs(x="Dropout Rate (%)",
       y = "GED Rate (%)")
{% endhighlight %}

<img src="/figure/./assets/Presentations/slides/Intro_analysis/unnamed-chunk-53-1.png" title="plot of chunk unnamed-chunk-53" alt="plot of chunk unnamed-chunk-53" style="display: block; margin: auto;" />
---

class: middle

## Data Cleaning and Modelling Tips

1. Always get a sense of your data first. 
  + Dipstick: Take a sample of a few cases, how do they look? As you'd expect?
  + Visualize and describe
  
1. After any transformation, make sure to compare a few cases in the raw data and the new data. 
  + use visualization to compare raw data and cleaned data.
  + Do they look right?
  
1. Careful, make sure your factors and or factors

1. Do your model results strain credulity? Too good to be true?
  + Use visualization to make sure there aren't weird cases
  + use descriptives

1. If you do any merging, take the "Dipstick" approach. 
  
1. If there's somebody you can work with, have them look at your code!

---
# Getting help in R

+ First, I hope this has been helpful.

+ I've posted a list of resources here: [**_Helplist_**](/help/helplist.html)

+ Next, please continue working at it. Today was probably really overwhelming. 

+ There are a lot of R resources out there!
---
## What should I continue to learn?

+ Overall, data management and cleaning (remember, tidy!)

+ Spreading and gathering from tidyr (soon to be [pivot_longer and pivot_wider](https://tidyr.tidyverse.org/dev/articles/pivot.html)

+ merging data with the [join functions from dply](https://dplyr.tidyverse.org/reference/join.html) and merging data by row (for example, long data) with [bind_rows](https://dplyr.tidyverse.org/reference/bind.html)

+ Check out how matrices work

+ Find something you need to do - do it

+ The joy of R is in writing functions and iteration.
---
## Finding help with Google

+ You'll often find "vignettes" - these are documents that people, often package authors, have created to give some in-depth examples.

+ You'll find the package documentation

+ You'll find other examples from classes, blogs, etc.

+ You'll find...Stack Exchange/Stack Overflow, and you will use it!

---

class: middle

## How to use Stack Overflow/Stack Exchange

+ Usual Scenario: Trying to do something, can't figure it out. 

+ You Google it and find a number of posts about your topic. You settle on one and there are a bunch of answers. 

+ Which one is right? Which one is best?

+ Usually, there are a few routes to your solution
---

class: middle

## Posts (try to find the most recent)

<img src="/google.jpg" title="plot of chunk unnamed-chunk-54" alt="plot of chunk unnamed-chunk-54" style="display: block; margin: auto;" />

---

class: middle

## Upvotes (Good Question)

<img src="/stackq.jpg" title="plot of chunk unnamed-chunk-55" alt="plot of chunk unnamed-chunk-55" style="display: block; margin: auto;" />

---
class: middle


***Answers (which one has the most upvotes? Which one matches)***

<img src="/upvoteold.jpg" title="plot of chunk unnamed-chunk-56" alt="plot of chunk unnamed-chunk-56" style="display: block; margin: auto;" />

---
class: middle


***People liked the answer from the previous slide but it's old, might be a solution: Scroll through non-featured***
<img src="/scroll.jpg" title="plot of chunk unnamed-chunk-57" alt="plot of chunk unnamed-chunk-57" style="display: block; margin: auto;" />
---

class: middle

***A featured new answer, but not as many upvotes! A solution and link!***
<img src="/newgood.jpg" title="plot of chunk unnamed-chunk-58" alt="plot of chunk unnamed-chunk-58" style="display: block; margin: auto;" />
---

class: middle

## Github

+ All R packages that are on `CRAN` have to be posted on Github

+ If you Google a package name, it's Github page comes up

+ Github is a project tracking/version control page where people can track and share projects. 

+ The R code here is usually the source code that makes a package work.
--
+ You rarely want this unless you want to know why you're getting some error and are maybe ready to scroll [*through lots and lots of code...*](https://github.com/philchalmers/mirt/blob/master/R/EMstep.utils.R)

+ But it **can** be [_**useful at times!**_](https://github.com/philchalmers/mirt/wiki)
---

class: middle

## Any other questions? Concerns?





