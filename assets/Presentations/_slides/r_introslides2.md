---
title: 'An Introduction to R: Data Cleaning, Wrangling, Visualizing, and Everything Else'
subtitle: 'Part 2'
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




# Enough Putzing about, Let's get to Data

+ The type of data structure you will mostly work with in R is the dataframe. Or, <mark>data.frame</mark> 

+ Other common types of data structures:
  + `matrix`
  + `lists`
  + `arrays`

---

class: middle

### Arrays

+ An array is a general multidimensional data structure 
  + mindblowingly, a matrix that essentially has an x, y, and a z axis (or more!)  
  
+ One can make lists of matrices or dataframes, and lists can be [_**IN dataframes**_](https://jennybc.github.io/purrr-tutorial/ls13_list-columns.html)
  + Sometimes, you want to do the same thing to a number of dataframes [_**iteration**_](https://r4ds.had.co.nz/iteration.html).
  + In a list, you have a method for doing this very easily 
  
---

class: middle

## Getting data sets in to R with the `readr` package
+ The first challenge: getting data into R

+ R needs a command to read in the data

+ R needs a <mark>path</mark>, where to find the data

+ We're going to use the [_**`readr`**_](https://readr.tidyverse.org/) package to handle most file types

#### However, the `foreign` package and `haven` package can handle files from SAS, SPSS, STATA

+ You don't need SPSS, SAS, or STATA to read data into R

---

class: middle

## First, things first
+ Download the data!

+ The data today is a publically accessible dataset from the [_**California Department of Education**_](https://www.cde.ca.gov/ds/sd/sd/filescohort.asp)

+ Download by clicking: [**Example Data 1**](/CDRPdata/cohort16.csv)

+ I've posted it on the workshop web here: [_**CDEDATA**_](http://www.dbkatz.com/1/01/01/beginning-a-new-intro-to-r-workshop/)

+ And put it in your working directory

+ My what?


{% highlight r %}
# this will tell you the file path of your current wd. 
getwd()
{% endhighlight %}



{% highlight text %}
## [1] "C:/Users/katzd/Desktop/Github/danielbkatz.github.io/assets/Presentations/slides"
{% endhighlight %}

---
## A Rare Best Practice

1. It is recommend that you create, in your working directory, folders just for the initial raw data (this data isn't to be altered) 

1. Another folder in your working directory just for altered datasets (with computed variables, cleaned, or otherwise changed data)

1. Another folder just for statistical output and plots (or divide)

<img src="/directory.jpg" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="90%" />


---

{% highlight text %}
## Error in file(con, "rb"): cannot open the connection
{% endhighlight %}
---

## Read in the data, the cheating way...
1. First create a new script in R, save it, and call it `learning_tidyverse`.

1.  In the top right, under the Global Environment tab, it says "Import Dataset"

1. The file we downloaded is a CSV file (make sure to use readr)

1. Select `Import Dataset` ➡️ `From Text (readr)` ➡️ `Browse` ➡️Find the dataset*, select, and open ➡️ look at the preview

1. If it doesn't look right, you can play with the settings (probably have to change delimiter)


# Don't import yet!

---

## The final steps
1. In the lower right, there is some code, <mark>copy it</mark> and cancel out

1. Paste the code into your new script at the top; write a note about what it is

1. Eventually, you'll want to do this manually, I promise (and please, promise me)

![plot of chunk unnamed-chunk-5](/importing.jpg)

---
## Code for Reading in 
+ Run all the code...



{% highlight r %}
# Now that I've put my files in a rawdata folder 
#in the working directory, I can do this:

# Load the library
library(readr)

co16 <- read_csv("RawData/cohort16.csv")
#Try out "View!"
View(co16)



#You can also save the object location (makes life easier)

# Assign a variable with a string value of the file location.
cohortdata <- "RawData/cohort16.csv"

# Put the variable in your function, `read_delim`
co16 <- read_csv(cohortdata)
{% endhighlight %}

---
class: middle

### Can also go searching for it with a longer path (doesn't need to be in your working directory)

{% highlight r %}
co16 <- read_csv("C:/Users/katzd/Desktop/Github/perswebsite2/static/CDRPdata/cohort16.csv")
{% endhighlight %}
---
## Missing data in R...
+ Missing data in `R` appears as `NA`

+ The philosophy in R regarding `NA` is that it's an unknown value

  + kind of like a latent variable (many consider latent variable modelling a solution to a missing data problem)

+ Base R won't compute certain statistics if you don't use the command `na.rm=T` which tells it to compute the statistic by removing the missing cases (where T = TRUE)

+ Because: The mean isn't known with missing values, truly


{% highlight r %}
# Example"
missingvector <- c(1,2, 3, 4, 5, NA)
mean(missingvector)
{% endhighlight %}



{% highlight text %}
## [1] NA
{% endhighlight %}



{% highlight r %}
mean(missingvector, na.rm = T)
{% endhighlight %}



{% highlight text %}
## [1] 3
{% endhighlight %}
---

class: middle 

# Introducing `dplyr` from the tidyverse
[_**`dplyr`**_](https://dplyr.tidyverse.org/) is a package full of "verbs" that help us work on data. Some major verbs are

+ <code>filter()</code> allows us to filter rows by certain values

+ <code>select()</code> allows us to select or deselect columns by name

+ <code>mutate()</code> allows us to create/compute new variables

---

## Data Sense

Let's get a sense of the data

{% highlight r %}
#get variable names

names(co16)
{% endhighlight %}



{% highlight text %}
##  [1] "X1"                         "CDS"                       
##  [3] "Name"                       "AggLevel"                  
##  [5] "DFC"                        "Subgroup"                  
##  [7] "Subgrouptype"               "NumCohort"                 
##  [9] "NumGraduates"               "Cohort Graduation Rate"    
## [11] "NumDropouts"                "Cohort Dropout Rate"       
## [13] "NumSpecialEducation"        "Special Ed Completers Rate"
## [15] "NumStillEnrolled"           "Still Enrolled Rate"       
## [17] "NumGED"                     "GED Rate"                  
## [19] "Year"
{% endhighlight %}
---
Get the first 10 rows

{% highlight r %}
head(co16)
{% endhighlight %}



{% highlight text %}
## # A tibble: 6 x 19
##      X1 CDS   Name  AggLevel DFC   Subgroup Subgrouptype NumCohort NumGraduates
##   <dbl> <chr> <chr> <chr>    <chr> <chr>    <chr>            <dbl>        <dbl>
## 1     1 0161~ REAL~ D        Y     All      9                   NA           NA
## 2     2 0161~ Impa~ D        Y     All      2                   NA           NA
## 3     3 0161~ Impa~ D        Y     All      9                   NA           NA
## 4     4 0161~ Impa~ D        Y     All      7                   NA           NA
## 5     5 0161~ Silv~ D        Y     All      5                   11           NA
## 6     6 0161~ Live~ D        Y     All      5                   27           27
## # ... with 10 more variables: `Cohort Graduation Rate` <dbl>,
## #   NumDropouts <dbl>, `Cohort Dropout Rate` <dbl>, NumSpecialEducation <dbl>,
## #   `Special Ed Completers Rate` <dbl>, NumStillEnrolled <dbl>, `Still Enrolled
## #   Rate` <dbl>, NumGED <dbl>, `GED Rate` <dbl>, Year <dbl>
{% endhighlight %}


---
## Using select to get RID of a column
#### We notice that the first column in the dataset is called `X1.` 

+ This column is added automatically when a dataframe is exported to csv from R. Let's get rid of it.  

We use a `-` sign before the column name. That's it. 


{% highlight r %}
co16_rem <- select(co16, -X1)

#non tidyverse solution (remember indexing!!)
co16_rem <- co16[-1]

#make sure this worked
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

## Checking our work

+ Remember when we talked about `class`?

+ Well, let's make sure `CDS` which is a school ID, is of class `character`, how will we do this?

+ We don't want school ID to be a "numeric" variable of some sort - It's an ID so leading zeros matter

+ Using another R index tool, `$`, which selects column by name (code complete should show you the name).

{% highlight r %}
class(co16_rem$CDS)
{% endhighlight %}
---

# What about all variables?: Introducing `str()`


{% highlight r %}
str(co16_rem)
{% endhighlight %}



{% highlight text %}
## Classes 'tbl_df', 'tbl' and 'data.frame':	75262 obs. of  18 variables:
##  $ CDS                       : chr  "01611430122697" "01611920113902" "01611920113902" "01611920113902" ...
##  $ Name                      : chr  "REALM Charter High" "Impact Academy of Arts & Technology" "Impact Academy of Arts & Technology" "Impact Academy of Arts & Technology" ...
##  $ AggLevel                  : chr  "D" "D" "D" "D" ...
##  $ DFC                       : chr  "Y" "Y" "Y" "Y" ...
##  $ Subgroup                  : chr  "All" "All" "All" "All" ...
##  $ Subgrouptype              : chr  "9" "2" "9" "7" ...
##  $ NumCohort                 : num  NA NA NA NA 11 27 50 61 NA NA ...
##  $ NumGraduates              : num  NA NA NA NA NA 27 47 55 NA NA ...
##  $ Cohort Graduation Rate    : num  0 100 50 100 63.6 ...
##  $ NumDropouts               : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ Cohort Dropout Rate       : num  100 0 50 0 27.3 0 4 1.6 12.5 0 ...
##  $ NumSpecialEducation       : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ Special Ed Completers Rate: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ NumStillEnrolled          : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ Still Enrolled Rate       : num  0 0 0 0 9.1 0 2 8.2 0 0 ...
##  $ NumGED                    : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ GED Rate                  : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ Year                      : num  1516 1516 1516 1516 1516 ...
{% endhighlight %}
Easy!
---

class: middle 

## Explaining the data set (this is especially good for the tidyverse)

+ The variable `CDS` is a code for county, district, and schools (an ID).

+ This data contains information from state level, to county level, to district level, to school level.

+ It also contains information about demographics. Each demographic group per school, gets its own row 
  
+ For instance, `AggLevel` denotes whether that row refers to "State", "County", "District," or "School"  
---

class: middle

+ If for instance, we take the first row, and first six columns
<table>
 <thead>
  <tr>
   <th style="text-align:left;"> CDS </th>
   <th style="text-align:left;"> Name </th>
   <th style="text-align:left;"> AggLevel </th>
   <th style="text-align:left;"> DFC </th>
   <th style="text-align:left;"> Subgroup </th>
   <th style="text-align:left;"> Subgrouptype </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 01611430122697 </td>
   <td style="text-align:left;"> REALM Charter High </td>
   <td style="text-align:left;"> D </td>
   <td style="text-align:left;"> Y </td>
   <td style="text-align:left;"> All </td>
   <td style="text-align:left;"> 9 </td>
  </tr>
</tbody>
</table>

+ This row represents district totals (so it's at the district level). 

+ District totals for the state-identified `Subgroup`, "All".  
(codebook, here: [_**California Department of Education**_](https://www.cde.ca.gov/ds/sd/sd/filescohort.asp), that's an aggregation)
  
+ `Subgrouptype` is 9, which refers to: `9 – Two or more races, not Hispanic`
  + Not stratified by "Gender" 
--

+ So that row refers to the district's total for all students who have been identified as `Two or more races, not Hispanic` (you really get to see how the state of CA thinks)

---
## Introducing `filter()` and pipe operators `%>%`

+ Let's say, we want to know about average graduation rate: For the entire state

+ I know that in the `Name` column, there's school names and a value called "Statewide"

+ `filter` literally filters rows that meet a certain rule, such as equaling a value

+ `filter(df, rule)`

{% highlight r %}
stateco16 <- filter(co16_rem, Name=="Statewide")
{% endhighlight %}
---


class: middle 


{% highlight r %}
stateco16 <- filter(co16_rem, Name=="Statewide")
{% endhighlight %}

#### We `filter` based on the value of a variable
  + The variable is `Name` 
  + It is of class, "character"
  + The value that we want is "Statewide"

+ This keeps only the cases where Name==Statewide
---
## Check for understanding, filter.

+ We only want to look at `district totals` data. 

+ Use filter, on AggLevel such that we only select the category `D`

+ Call this new dataframe that you create "distr"

+ You'll have to start with `co16_rem` 
--
## solution

{% highlight r %}
distr <- filter(co16_rem, AggLevel == "D")

# Did it work?
table(distr$AggLevel)
{% endhighlight %}



{% highlight text %}
## 
##     D 
## 19585
{% endhighlight %}



{% highlight r %}
#vs.

table(co16_rem$AggLevel)
{% endhighlight %}



{% highlight text %}
## 
##     D     O     S     T 
## 19585  1814 53829    34
{% endhighlight %}
---

class: middle

## Piping Operators

+ However, we don't want to create a new object in R every time you perform an operation (we often perform a lot of operations and this gets confusing)

+ The `%>%` operator, helps - read it as `and then`

+ Read the code: Take co16_rem, then filter it (rule)


{% highlight r %}
distr <- co16_rem %>% 
  filter(AggLevel == "D")

# table gives you counts on column (remember $ indexes)
table(distr$AggLevel)
{% endhighlight %}



{% highlight text %}
## 
##     D 
## 19585
{% endhighlight %}

*What about filtering on more than one variable? That sounds like a challenge!*
---

After filtering for District, individual charter schools are left in the dataset. 
.pull-left[
1. The variable, <mark>DFC</mark> contains information as to whether a school is a charter school or not. 
  + Y = Charter School
  + N = Not a charter school

2. The variable <mark>AggLevel</mark> has information on level of analysis where
  + D = Local educational agency totals (includes districts and direct funded charter schools)
  + O = County totals
  + S = School totals
  + T = State totals]

.pull-right[1. Starting with the dataframe, `co16_rem`, create a new dataframe called `cocharter` by...

2. using `filter` so we only keep districts but remove charter schools.

3. Use filter and/or pipes so you only need to create one dataframe 

3. If you need the codebook, it is here: [_**California Department of Education**_](https://www.cde.ca.gov/ds/sd/sd/filescohort.asp)]

#### *Hint* You can do this with one pipe or two. Filter can take multiple arguments

---
# Solutions


{% highlight r %}
# Either one will work, I prefer method1
nocharter <- co16_rem %>% 
  filter(DFC == "N", AggLevel == "D")

# or...

nocharter <- co16_rem %>% 
  filter(DFC=="N") %>% filter(AggLevel=="D")
{% endhighlight %}
---
# Challenge
1.After filtering, what categories are still left in the variable, `Agglevel`, in your new dataframe, nocharter?

1. Without creating a new R object, edit your script such that you keep only the category `All` from variable `Subgroup` and `All` from variable `Subgrouptype`. Make sure it is still called `nofilter`

---

## Solutions

{% highlight r %}
nocharter <- co16_rem %>% 
  filter(DFC == "N", AggLevel == "D", 
                              Subgroup=="All", 
                              Subgrouptype=="All")

nocharter
{% endhighlight %}



{% highlight text %}
## # A tibble: 493 x 18
##    CDS   Name  AggLevel DFC   Subgroup Subgrouptype NumCohort NumGraduates
##    <chr> <chr> <chr>    <chr> <chr>    <chr>            <dbl>        <dbl>
##  1 0110~ Alam~ D        N     All      All                312          109
##  2 0161~ Alam~ D        N     All      All                727          632
##  3 0161~ Cast~ D        N     All      All                779          749
##  4 0161~ Pied~ D        N     All      All                206          205
##  5 0410~ Butt~ D        N     All      All                 76           37
##  6 0461~ Chic~ D        N     All      All               1093          979
##  7 0461~ Durh~ D        N     All      All                 67           65
##  8 0475~ Grid~ D        N     All      All                182          163
##  9 0861~ Del ~ D        N     All      All                216          197
## 10 1062~ Fres~ D        N     All      All               4488         3839
## # ... with 483 more rows, and 10 more variables: `Cohort Graduation
## #   Rate` <dbl>, NumDropouts <dbl>, `Cohort Dropout Rate` <dbl>,
## #   NumSpecialEducation <dbl>, `Special Ed Completers Rate` <dbl>,
## #   NumStillEnrolled <dbl>, `Still Enrolled Rate` <dbl>, NumGED <dbl>, `GED
## #   Rate` <dbl>, Year <dbl>
{% endhighlight %}
---
## "Remember our logical operators" Challenge

1. Now, using a pipe and assigning a new variable called `nocharter1000`, start with nocharter such that nocharter1000 only has districts with _at least_ 1000 students in its cohort (you'll need the variable NumCohort). 

1. The variable you'll need to filter on is "NumCohort"

---
## Solutions

{% highlight r %}
table(nocharter$AggLevel)
{% endhighlight %}



{% highlight text %}
## 
##   D 
## 493
{% endhighlight %}



{% highlight r %}
nocharter1000 <- nocharter %>%
  filter(NumCohort >= 1000)

range(nocharter1000$NumCohort, na.rm = T)
{% endhighlight %}



{% highlight text %}
## [1]  1000 34472
{% endhighlight %}



{% highlight r %}
nrow(nocharter1000) 
{% endhighlight %}



{% highlight text %}
## [1] 136
{% endhighlight %}
---


class: middle


# Non-tidyverse solutions to filtering rows

*If I want to select particular rows, say, row 1, along with the fourth column:*
+ `newdf <- co16_rem[1, 4]` (where the first element represents row number, after the comma, the column (just like a matrix))

+ Just the first row: `newdf <- co16_rem[1, ]`

*If I want to select rows according to rule (say, 1000)*:

`newdf <- co16_rem[co16_rem$numcohort >= "1000", ]`

---

class: middle 

## For non-tidyverse solutions for selecting columns:
  + Indexing: `co16_rem[1:4]` (note, don't need commas) but same as `co16_rem[, 1:4]`
  
  + By name, use, `$`:  `co16_rem$AggLevel`

---
class: middle

## tidyverse solution to selecting columns

+ Re-introducing `select()`

+ `select()` takes a dataframe name and the name of the columns you wish to select.

+ Typical use involves taking a very large dataset and selecting only the columns you need. 

+ You can also use `select()` to reorder columns, remove columns, and rename columns

--

+ General Format: `select(df, columns_you_wish_to_select, by name)`

---
class: middle

# Example use:



{% highlight r %}
state16 <- co16_rem %>% 
  select(CDS, Name, NumCohort, 
         NumGraduates,
         `Cohort Graduation Rate`, NumDropouts)

# without a pipe operator
state16 <- select(co16_rem , #<<
                  CDS,
                  Name, NumCohort, NumGraduates, 
                  `Cohort Graduation Rate`, NumDropouts)


names(state16)
{% endhighlight %}



{% highlight text %}
## [1] "CDS"                    "Name"                   "NumCohort"             
## [4] "NumGraduates"           "Cohort Graduation Rate" "NumDropouts"
{% endhighlight %}



{% highlight r %}
#or
View(state16)
{% endhighlight %}
---

class: middle 
## what else can you do with `select`? 
+ Re-order columns: Select in the order that you want the variable to appear

Ex: If I want to see "Cohort Graduation Rate" first:

+ `state16 <- co16_rem %>% 
  select(`Cohort Graduation Rate`, CDS, Name, NumCohort, NumGraduates, NumDropouts)`

If I want to rename a column in the process of selecting the format is:

  `newdf <- old_df %>% 
  select(newname=oldname, var1, var2)`
  
---

class: middle

# Check for understanding `select()`:

1. Edit the code:
`state16 <- co16_rem %>%` 
  to select all variables listed in the table below.

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> Variable_Name </th>
   <th style="text-align:left;"> Variable_Description </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> CDS </td>
   <td style="text-align:left;"> County, District, or School ID </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Name </td>
   <td style="text-align:left;"> Name of State, County, District, or School </td>
  </tr>
  <tr>
   <td style="text-align:left;"> AggLevel </td>
   <td style="text-align:left;"> Level of Row Observation Statewide Totals(T), County Totals (0), District/Local Education Agency Totals (D), School Totals (S) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> DFC </td>
   <td style="text-align:left;"> Direct Funded Charter: Yes (Y), No (N) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Subgroup </td>
   <td style="text-align:left;"> This is a coded field for identifying subgroups of students, such as, program participation and gender </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Subgrouptype </td>
   <td style="text-align:left;"> This is a coded field for identifying racial/ethnic designation </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NumCohort </td>
   <td style="text-align:left;"> Number of Students in the Cohort </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NumGraduates </td>
   <td style="text-align:left;"> Number of students who graduated from the cohort </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NumDropouts </td>
   <td style="text-align:left;"> Number of Students Recorded as Dropping Out of School </td>
  </tr>
</tbody>
</table>



---
# Solutions

{% highlight r %}
state16 <- co16_rem %>% 
  select(CDS:NumGraduates, NumDropouts)
                  
   
names(state16)
{% endhighlight %}



{% highlight text %}
## [1] "CDS"          "Name"         "AggLevel"     "DFC"          "Subgroup"    
## [6] "Subgrouptype" "NumCohort"    "NumGraduates" "NumDropouts"
{% endhighlight %}
---
## Adding more to select()
1. Using `select()`, edit your code from above to **ALSO** select the variables listed below while  renaming them 
  + Rename `Cohort Graduation Rate` to `gradrate`
  + Rename `Cohort Dropout Rate` to `droprate`
  + Rename `GED Rate` to `GEDrate`
  
Creating a new dataframe called state16d, and using a pipe operator

1. add a filter command to your code, such that you select 
  + only district level data, D, (from `AggLevel`) 
  + only non-charter schools, N, (from `DFC`)
  + only `All` from both `Subgroup` and `Subgrouptype`
  
1. What is the largest value for `Numcohort`?
---
## Solutions


{% highlight r %}
state16 <- co16_rem %>% select(CDS:NumGraduates, 
                               NumDropouts,
                      gradrate = `Cohort Graduation Rate`,
                      droprate = `Cohort Dropout Rate`,
                      GEDrate = `GED Rate`)

state16d <- state16 %>% 
  filter(AggLevel=="D", DFC=="N", Subgroup=="All", 
         Subgrouptype=="All")
{% endhighlight %}


{% highlight r %}
range(state16d$NumCohort, na.rm=T)
{% endhighlight %}



{% highlight text %}
## [1]    11 34472
{% endhighlight %}



{% highlight r %}
max(state16d$NumCohort, na.rm=T)
{% endhighlight %}



{% highlight text %}
## [1] 34472
{% endhighlight %}

Easy! 
---

class: middle

## Sometimes these methods can be tedious

+ You can use select functionally, that is, you can select based on a rule

+ If a variable name contains a certain string e.g. `state16 %>% select(contains("Num"), ends_with("ort"))`

+ If a variable is numeric: `state16 %>% select_if(is.numeric)`

+ These are just a few examples, if it can be evaluated with a logical, you can use select_if (or any dplyr verb conditionally)

+ Read more [**here**](https://www.rdocumentation.org/packages/dplyr/versions/0.5.0/topics/select_if): 
---
## Names

+ You can rename files using: 

`names(df)[column_numbers] <- c("name for first column", "name for second column")`

Example:


{% highlight r %}
#to have a throw away datafram
co16_test <- co16_rem

names(co16_test)[1:5] <- c("ID", 
                           "Title", 
                           "Stateleveltoschoollevel", 
                           "Charter", 
                           "Classification")

names(co16_test)
{% endhighlight %}



{% highlight text %}
##  [1] "ID"                         "Title"                     
##  [3] "Stateleveltoschoollevel"    "Charter"                   
##  [5] "Classification"             "Subgrouptype"              
##  [7] "NumCohort"                  "NumGraduates"              
##  [9] "Cohort Graduation Rate"     "NumDropouts"               
## [11] "Cohort Dropout Rate"        "NumSpecialEducation"       
## [13] "Special Ed Completers Rate" "NumStillEnrolled"          
## [15] "Still Enrolled Rate"        "NumGED"                    
## [17] "GED Rate"                   "Year"
{% endhighlight %}
---
## Or use tidyverse `rename()`

{% highlight r %}
co16_test <- co16_rem %>% 
  rename("NEWCODE"=CDS, 
         "Title"=Name, 
         "Level"=AggLevel)

names(co16_test)
{% endhighlight %}



{% highlight text %}
##  [1] "NEWCODE"                    "Title"                     
##  [3] "Level"                      "DFC"                       
##  [5] "Subgroup"                   "Subgrouptype"              
##  [7] "NumCohort"                  "NumGraduates"              
##  [9] "Cohort Graduation Rate"     "NumDropouts"               
## [11] "Cohort Dropout Rate"        "NumSpecialEducation"       
## [13] "Special Ed Completers Rate" "NumStillEnrolled"          
## [15] "Still Enrolled Rate"        "NumGED"                    
## [17] "GED Rate"                   "Year"
{% endhighlight %}

New names on the left of the `=`, in quotes.
---
class: middle

## Getting fancy

If you want to find the district with the largest cohort via dplyr:


{% highlight r %}
state16d %>% 
  filter(NumCohort==max(NumCohort, na.rm=T)) %>% 
  select(Name)
{% endhighlight %}



{% highlight text %}
## # A tibble: 1 x 1
##   Name               
##   <chr>              
## 1 Los Angeles Unified
{% endhighlight %}

---
class: middle

## Something we haven't talked about yet... Variable types

+ The typical sort of stuff you see in SPSS for "types of variables" exists in R

+ Some of the major data structures you'll find that R recognizes:
  + `Character` - string variables/words/unordered
  + `Factors` - Categorical variable, usually ordered
  + `Numeric` (common types are integer and double, but it almost never matters [see here](https://www.burns-stat.com/documents/tutorials/impatient-r/more-r-key-objects/more-r-numbers/))
  + `Logical` (of the value, TRUE (T) or FALSE (F) or sometimes 1 or 0)
  + `Date and/or Time`


---

class: middle
### More on logicals

+ `TRUE` or `FALSE` have their own meaning in R - R knows what they mean

+ Always corresponds to 1 or 0 

+ As an example, run the code `T*1` and `F*1` 

+ If you remember the booleans, such as `<=` they're evaluated as `TRUE` or `FALSE` 

---

class: middle 

## How R uses Logicals
#### When filtering, what we're really saying is...  _If this statement is TRUE, keep or discard these cases_

+ You can have an entire column in a dataframe that is a set of logicals (whether a student partook in a certain curriculum)

+ You might have a column of 1s or 0s - But you need R to recognize it as a Boolean or at least a factor.

+ We'll have to coerce the column in a data frame, but first, `mutate()`
---

## Mutate

+ `Mutate()` is a function in dplyr used to create new columns or change existing ones. 

+ General form: `Mutate(df, new_variable_name = some_operation)`

+ Let's say I want to check if my cohort and enrollment numbers match the graduation rate of that the state calculated. 


{% highlight r %}
state16d <- state16d %>% 
  mutate(gradrate_calc = NumGraduates/NumCohort)

head(state16d[5:length(state16d)])
{% endhighlight %}



{% highlight text %}
## # A tibble: 6 x 9
##   Subgroup Subgrouptype NumCohort NumGraduates NumDropouts gradrate droprate
##   <chr>    <chr>            <dbl>        <dbl>       <dbl>    <dbl>    <dbl>
## 1 All      All                312          109         148     34.9     47.4
## 2 All      All                727          632          39     86.9      5.4
## 3 All      All                779          749          18     96.2      2.3
## 4 All      All                206          205          NA     99.5      0.5
## 5 All      All                 76           37          19     48.7     25  
## 6 All      All               1093          979          78     89.6      7.1
## # ... with 2 more variables: GEDrate <dbl>, gradrate_calc <dbl>
{% endhighlight %}

---

class: middle

## Challenge, `mutate()` and using assignment
1. Create a column using mutate that gives a standardized value of NumCohort for Districts in `State16d`. Call the column `StandCohort`

2. Select all the cases in State16 that are at least two standard deviations above the mean NumCohort value based on your standardization

*Standardization/Z-Score = $\Sigma(x-\mu)/\sigma$*
1. You'll need to get the mean of Numcohort. 
1. You'll need to get the standard deviation of Numcohort. 


---
## Solution


{% highlight r %}
#### easier ###
mu <- mean(state16d$NumCohort, na.rm = T)
sigma <- sd(state16d$NumCohort, na.rm = T)

twosigma <- state16d %>% 
  mutate(StandCohort=(NumCohort-mu)/sigma) %>% 
  filter(StandCohort >= 2)

View(twosigma)
{% endhighlight %}


{% highlight r %}
# harder
twosigma <- state16d %>% mutate(StandCohort = (NumCohort - mean(NumCohort, na.rm = T))/sd(NumCohort, 
    na.rm = T)) %>% filter(StandCohort >= 2)
{% endhighlight %}


{% highlight r %}
# Best: using the function, scale()!!
state16 <- state16d %>% 
  mutate(StandCohort= scale(NumCohort)) %>% 
  filter(StandCohort >= 2)
{% endhighlight %}
---
# If and Else

+ What if I wanted to create a dummy variable for `standcohort>=2` or not instead of filtering

+ Introducing if_else

+ Rule mutate = if_else(df, Variable == val, TRUE_value, False_value)


{% highlight r %}
districtlarge <- state16d %>% 
  mutate(StandCohort= scale(NumCohort)) %>%
  mutate(Large = if_else(StandCohort >= 2, 1,0)) #<<

table(districtlarge$Large)
{% endhighlight %}



{% highlight text %}
## 
##   0   1 
## 465   9
{% endhighlight %}

---
class: middle 
## Can nest 

+ If StandCohort >= 1, Large =1 
+ If StandCohort >= 1, Large =2
+ Otherwise, Large = 0

{% highlight r %}
districtlarge <- state16d %>% 
  mutate(StandCohort= scale(NumCohort)) %>%
  mutate(Large = if_else(StandCohort >= 1, 1,
                 if_else(StandCohort >= 2, 2, 0)))

table(districtlarge$Large)
{% endhighlight %}



{% highlight text %}
## 
##   0   1 
## 446  28
{% endhighlight %}

---

class: middle

## Coercing
+ In R, factors have labels, like in SPSS.

+ We can use factors to add a label, so that in the data frame, we can see 1, but it has a label of "Participated" (or something like that)

+ Let's start with `co16_rem` but let's make it smaller.

+ Select, `CDS`, `Name`, `AggLevel`, `DFC` using a `:` (because all the columns are in a row (`CDS` THROUGH `DFC`)
--


{% highlight r %}
co16dat <- co16_rem %>% 
  select(CDS:DFC)
{% endhighlight %}

---

## Exploring the dataset
+ First, let's check out the structure of the dataframe, co16dat


{% highlight r %}
class(co16dat)
{% endhighlight %}



{% highlight text %}
## [1] "tbl_df"     "tbl"        "data.frame"
{% endhighlight %}

(Tibble is a dplyr specific object, hence, tbl, read about [Tibbles](https://r4ds.had.co.nz/tibbles.html#tibbles-vs.data.frame))
--

### Let's figure out what class each column is using str()


{% highlight r %}
str(co16dat)
{% endhighlight %}



{% highlight text %}
## Classes 'tbl_df', 'tbl' and 'data.frame':	75262 obs. of  4 variables:
##  $ CDS     : chr  "01611430122697" "01611920113902" "01611920113902" "01611920113902" ...
##  $ Name    : chr  "REALM Charter High" "Impact Academy of Arts & Technology" "Impact Academy of Arts & Technology" "Impact Academy of Arts & Technology" ...
##  $ AggLevel: chr  "D" "D" "D" "D" ...
##  $ DFC     : chr  "Y" "Y" "Y" "Y" ...
{% endhighlight %}
---
## Another way to explore a data set (and aside/introduction to apply())

+ apply(df, index, function) is the R version of a `for loop`: it iterates across rows and columns 
  + Index =1 performs some operation over rows
  + Index =2 performs some operation over columns

+ So, to get the class of each variable:


{% highlight r %}
apply(co16dat, 2, class)
{% endhighlight %}



{% highlight text %}
##         CDS        Name    AggLevel         DFC 
## "character" "character" "character" "character"
{% endhighlight %}
---
## Challenge `apply()`

+ Replace `class` with the function `table`
+ Look only at the last two columns of co16dat. 

*Hint*: Remember indexing (though, there are other ways)
--

{% highlight r %}
apply(co16dat[3:4], 2, table)
{% endhighlight %}



{% highlight text %}
## $AggLevel
## 
##     D     O     S     T 
## 19585  1814 53829    34 
## 
## $DFC
## 
##     N     Y 
## 61024 14238
{% endhighlight %}



{% highlight r %}
#or to get a cross tab

co16dat %>% select(AggLevel, DFC) %>% table()
{% endhighlight %}



{% highlight text %}
##         DFC
## AggLevel     N     Y
##        D 12466  7119
##        O  1814     0
##        S 46710  7119
##        T    34     0
{% endhighlight %}

---

class: middle

### Let's make DFC a factor, right now it's of class character


{% highlight r %}
co16dat <- co16_rem %>% 
  select(CDS:DFC)

## We're going to call out the column by name
co16dat$DFC <- as.factor(co16dat$DFC)


# levels() tells us what's in the factor.
levels(co16dat$DFC)
{% endhighlight %}



{% highlight text %}
## [1] "N" "Y"
{% endhighlight %}

---
## But what if I want to add labels?
+ Best practice: make sure that if you transform a variable within a data.frame, but don't make the dataframe a new object, that you make it a new variable


{% highlight r %}
#make a new column name
co16dat$DFCfactor2 <- factor(co16dat$DFC,
                      levels = c("Y", "N"),
                      labels = c("Charter", "Not_Charter"))
levels(co16dat$DFC)
{% endhighlight %}



{% highlight text %}
## [1] "N" "Y"
{% endhighlight %}

# What if it involves numbers?
---

## We'll use a built-in R dataset for this
You don't need to load any data but to get a feeling type: `View(mpg)`


{% highlight r %}
table(mpg$cyl)
{% endhighlight %}



{% highlight text %}
## 
##  4  5  6  8 
## 81  4 79 70
{% endhighlight %}



{% highlight r %}
class(mpg$cyl)
{% endhighlight %}



{% highlight text %}
## [1] "integer"
{% endhighlight %}



{% highlight r %}
# assign a new name so we don't mess up the base R dataset
# Let's make the variable cyl an ordinal variable with labels and mutate
# Ordered tells R that the factor is ordered bu could also use factor
mpg2 <- mpg %>% 
  mutate(cyl2 = ordered(cyl, 
                levels = c(4, 5, 6, 8),
                labels = c("Smallest", 
                            "Small", 
                            "Medium", 
                            "Large")))

levels(mpg2$cyl2)
{% endhighlight %}



{% highlight text %}
## [1] "Smallest" "Small"    "Medium"   "Large"
{% endhighlight %}

---
class: middle
#### Just be careful, especially with values coded as 1 or 0 and numeric but represent two categories:

+ You either turn it into a logical using `as.logical` or a factor before analysis.  


---

## Challenge, factors
1. Using `mpg2`, turn the variable in mpg2, "class" into a factor variable.
2. Make the levels go from 2seater:suv
--


{% highlight r %}
table(mpg2$class)
{% endhighlight %}



{% highlight text %}
## 
##    2seater    compact    midsize    minivan     pickup subcompact        suv 
##          5         47         41         11         33         35         62
{% endhighlight %}



{% highlight r %}
class(mpg2$class)
{% endhighlight %}



{% highlight text %}
## [1] "character"
{% endhighlight %}



{% highlight r %}
mpg2 <- mpg2 %>% 
  mutate(class2 = ordered(class,
         levels = c("2seater", "compact", "midsize", 
                    "minivan", "pickup", "subcompact", "suv")))

class(mpg2$class2)
{% endhighlight %}



{% highlight text %}
## [1] "ordered" "factor"
{% endhighlight %}

---
# There are much more on factors than I could cover in this workshop

+ If you want to read more, go [here](https://r4ds.had.co.nz/factors.html)

+ Particularly powerful is `fct_recode` from the `forcats` package of the tidyverse 
  + Allows you to recode levels, collapse levels, or change level names.
---
### Example of `fct_recode`

Example: using the general social survey, gss (example from [https://r4ds.had.co.nz/factors.html#modifying-factor-levels](https://r4ds.had.co.nz/factors.html#modifying-factor-levels))


{% highlight r %}
# using built in dataset gss_cat
examplegss <- gss_cat %>% select(partyid)

# partyid is a factor

#create a new name on the left, the old name on the right
recodeparty <- examplegss %>% mutate(partyid = fct_recode(partyid,
    "Republican, strong"    = "Strong republican",
    "Republican, weak"      = "Not str republican",
    "Independent, near rep" = "Ind,near rep",
    "Independent, near dem" = "Ind,near dem",
    "Democrat, weak"        = "Not str democrat",
    "Democrat, strong"      = "Strong democrat"
  )) %>% count(partyid)
{% endhighlight %}
---

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> partyid </th>
   <th style="text-align:right;"> n </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> No answer </td>
   <td style="text-align:right;"> 154 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Don't know </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Other party </td>
   <td style="text-align:right;"> 393 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Republican, strong </td>
   <td style="text-align:right;"> 2314 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Republican, weak </td>
   <td style="text-align:right;"> 3032 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Independent, near rep </td>
   <td style="text-align:right;"> 1791 </td>
  </tr>
</tbody>
</table>
---
# Challenge, fct_recode()

1. Using fct_recode with the `mpg` data, collapse categories so that there are only two categories in the variable, cyl2:

  + `small` for 4 and 5 cylinder, 
  + `Large`, for 6 and 8 cylinders.  

---
# Solution

{% highlight r %}
table(mpg2$cyl2)
{% endhighlight %}



{% highlight text %}
## 
## Smallest    Small   Medium    Large 
##       81        4       79       70
{% endhighlight %}



{% highlight r %}
mpg2 <- mpg2 %>%
  mutate(cyl2 = fct_recode(cyl2,
           "Small"= "Smallest",
           "Small"= "Small",
            "Large"= "Medium"))

# fct_recode: According to data-science with R, fct_recode() will leave levels that aren’t mentioned, and will warn you if you accidentally refer to a level that doesn’t exist.
sum(table(mpg2$cyl2))
{% endhighlight %}



{% highlight text %}
## [1] 234
{% endhighlight %}



{% highlight r %}
sum(table(mpg2$cat.cyl))
{% endhighlight %}



{% highlight text %}
## [1] 0
{% endhighlight %}
---
# Ok, Finally, some analysis...Go to Part III ##


