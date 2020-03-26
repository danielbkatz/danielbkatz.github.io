---
title: 'Challenge: Merging data'
author: "Danny"
date: "6/17/2019"
output: html_document
---



## Merging Data

Merging is a common task that needs to happen in typical data analytic tasks. Using the language of `SQL`, the tidyverse uses "joins" and "bind."

#### An example in which one might "join":  
I have data on students from a school district and data on the same students from the individual schools.  

1. Both data sets have unique information. For instance, the school district data has student demographic information and the school-level data has student grades. The school doesn't have demographic data and the district doesn't have grades. 

1. Both use the same ID for each student (so, John Doe has ID 110 in both data sets.)

1. I "join the data" by putting the two files together matching on the student ID. 

Ex:



{% highlight text %}
## # A tibble: 2 x 3
##   ID    Name     Age  
##   <chr> <chr>    <chr>
## 1 0101  Student1 11   
## 2 10101 Student2 12
{% endhighlight %}




{% highlight text %}
## # A tibble: 2 x 2
##   ID    Grade
##   <chr> <chr>
## 1 0101  A    
## 2 10101 B
{% endhighlight %}
Then we use a "left_join" (not the by):


{% highlight r %}
mergedtable <- left_join(table1, table2, by = "ID")
{% endhighlight %}


{% highlight text %}
## # A tibble: 2 x 4
##   ID    Name     Age   Grade
##   <chr> <chr>    <chr> <chr>
## 1 0101  Student1 11    A    
## 2 10101 Student2 12    B
{% endhighlight %}

If this had multiple years of grades across the top such as the table below, it would be referred to as non-tidy data (or simple, "wide data"). Typical wide-data formats include survey responses, in which each column across the top pertains to a particular item response.  


{% highlight text %}
## # A tibble: 2 x 4
##   mergedtable$ID $Name    $Age  $Grade Grade2014 Grade2015 Grade2016
##   <chr>          <chr>    <chr> <chr>  <chr>     <chr>     <chr>    
## 1 0101           Student1 11    A      B         C         A        
## 2 10101          Student2 12    B      B         C         A
{% endhighlight %}
## Binding rows

Another way to merge data is when you want to have "long data" or if you're simply adding cases. 

Let say you you don't want to have wide data, you want to have long data. You receive datasets from the school that looks like:


<table style="text-align:center"><tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td>ID</td><td>Grade</td><td>Year</td></tr>
<tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">1</td><td>0101</td><td>A</td><td>2012</td></tr>
<tr><td style="text-align:left">2</td><td>10101</td><td>B</td><td>2012</td></tr>
<tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr></table>

<table style="text-align:center"><tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td>ID</td><td>Grade</td><td>Year</td></tr>
<tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">1</td><td>0101</td><td>A</td><td>2013</td></tr>
<tr><td style="text-align:left">2</td><td>10101</td><td>C</td><td>2013</td></tr>
<tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr></table>
We have two data sets that have three of the same variable names. What we want to do is "bind_rows" to put them together.


{% highlight r %}
longdat <- bind_rows(tableg1, tableg2)
stargazer(longdat, type="html", summary=F) 
{% endhighlight %}


<table style="text-align:center"><tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td>ID</td><td>Grade</td><td>Year</td></tr>
<tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">1</td><td>0101</td><td>A</td><td>2012</td></tr>
<tr><td style="text-align:left">2</td><td>10101</td><td>B</td><td>2012</td></tr>
<tr><td style="text-align:left">3</td><td>0101</td><td>A</td><td>2013</td></tr>
<tr><td style="text-align:left">4</td><td>10101</td><td>C</td><td>2013</td></tr>
<tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr></table>

## Types of joins: Mutating Joins

There are many different types of ["mutating joins"](https://dplyr.tidyverse.org/reference/join.html). These joins keep columns from all the data frames you're using.

A join takes the form `left_join(x=df1, y=df2, CDS =key)` where key can be one common column. You can use multiple keys, say, if you want to match on ID and date using, `left_join(x=df1, y=df2, CDS =c(ID, Date))` 

+ `left_join()`: Keeps all rows on the left, x dataframe, while returning only matched rows from the `y` data frame. Columns from both dataframes are returned. Cases where there's an `X` but no match on `y` are returned with value NA. 

+ `Right_join()`: The same as a `left_join` but keeps all rows on right (`y`) instead of left. 

+ `full_join()`: Returns all columns and all cases from both `x` and `y`.

The image from [R for Data Science by Grolemund and Wickham](https://r4ds.had.co.nz/) is very helpful.


{% highlight text %}
## Error in knitr::include_graphics("joins.png"): Cannot find the file(s): "joins.png"
{% endhighlight %}

Another way to think about joins:


{% highlight text %}
## Error in knitr::include_graphics("joinvenn.png"): Cannot find the file(s): "joinvenn.png"
{% endhighlight %}

# Filtering Joins: Using joins to filter cases

`semi_join()`: If you have data.frame `x` and data.frame `y`, a semijoin will return just the rows from x where there is a match with `y` and only the columns with `x`.

`anti_join()`: Only returns non-matches in `x` and `y` and only the columns from x. 

# Exercises:
1. Download and read-in the data from [here]("CDRPdata/Exampledat2.csv")
  + Notice year is actually coded 1-6. 1 pertains to academic year 2009-2010 and 6 pertains to 2014-2015. 
  
2. What happens when you create a dataframe using left_join with co16_rem and the new example data, where the new example data is `x`. 

3. What happens when you right_join?

4. What happens when you semi_join with the new example data on the left, and co16_rem on the right?

# Binding rows

Sometimes, instead, you'd rather "stack" dataframes, such as in the case of timeseries data. For instance, in the new data set, each row pertains to a year and subgroup and district. If we get new data, we'll want to, instead of adding to the data to make it wider, simply add more cases! We're adding more observations. 

This is a form of tidydata. 





