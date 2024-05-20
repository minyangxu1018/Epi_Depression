cd "/Users/minyangmaxims_xu/Library/CloudStorage/GoogleDrive-mx2269@nyu.edu/My Drive/2024 Spring/GU2450/Project"
use "Depression_data for ANALYSIS PROJECT.dta", clear
browse
sum seqn
use "NHANES_dataset for ANALYSIS PROJECT.dta", clear
browse
sum seqn
sort seqn
merge 1:1 seqn using "Depression_data for ANALYSIS PROJECT.dta"
sum seqn
gen eligible = ridageyr >= 18 & !mi(dpq010, dpq020, dpq030, dpq040, dpq050, dpq060, dpq070, dpq080, dpq090)
tab eligible
**# Bookmark #1
drop if eligible==0



* Check the merge results
tabulate _merge
drop if _merge == 2
drop if dpq010 == 7 | dpq010 == 9 | dpq010 == .
drop if dpq020 == 7 | dpq020 == 9 | dpq020 == .
drop if dpq030 == 7 | dpq030 == 9 | dpq030 == .
drop if dpq040 == 7 | dpq040 == 9 | dpq040 == .
drop if dpq050 == 7 | dpq050 == 9 | dpq050 == .
drop if dpq060 == 7 | dpq060 == 9 | dpq060 == .
drop if dpq070 == 7 | dpq070 == 9 | dpq070 == .
drop if dpq080 == 7 | dpq080 == 9 | dpq080 == .
drop if dpq090 == 7 | dpq090 == 9 | dpq090 == .
drop if dmdeduc2 == 7 | dmdeduc2 == 9
drop if dmdmartz == 77 | dmdmartz == 99 | dmdmartz == .
drop if indfmpir == .
drop if hiq011 == 7 | hiq011 == 9



tab _merge


tab ridageyr
tab ridage
tab riagendr


********************************************
* Recode
********************************************
* Age category
recode ridageyr (18/24=1) (25/44=2) (45/64=3) (65/max=4), generate(age_category)
label define agecat 1 "19-24" 2 "25-44" 3 "45-64" 4 "65+"
label values age_category agecat

* Depression score
gen depression_score = dpq010 + dpq020 + dpq030 + dpq040 + dpq050 + dpq060 + dpq070 + dpq080 + dpq090
summarize depression_score, detail





* Summarize the poverty ratio variable
summarize indfmpir, detail
*              Ratio of family income to poverty
*-------------------------------------------------------------
*      Percentiles      Smallest
* 1%          .04              0
* 5%          .41              0
*10%           .7              0       Obs               6,840
*25%          1.2              0       Sum of wgt.       6,840
*
*50%         2.29                      Mean           2.625509
*                        Largest       Std. dev.      1.625701
*75%         4.25              5
*90%            5              5       Variance       2.642905
*95%            5              5       Skewness        .250574
*99%            5              5       Kurtosis       1.655616

    


* Gender analysis
tabulate riagendr

* Age Analysis
summarize ridageyr, detail

*                  Age in years at screening
*-------------------------------------------------------------
*      Percentiles      Smallest
* 1%           20             20
* 5%           23             20
*10%           26             20       Obs               6,840
*25%           36             20       Sum of wgt.       6,840
*
*50%           52                      Mean           50.76959
*                        Largest       Std. dev.      17.38886
*75%           64             80
*90%           75             80       Variance       302.3724
*95%           80             80       Skewness      -.0339568
*99%           80             80       Kurtosis       1.894221

* Education Level analysis
tab dmdeduc2
/*
  Education |
    level - |
 Adults 20+ |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |        419        6.13        6.13
          2 |        721       10.54       16.67
          3 |      1,646       24.06       40.73
          4 |      2,318       33.89       74.62
          5 |      1,736       25.38      100.00
------------+-----------------------------------
      Total |      6,840      100.00

*/

* Marital Status analysis 
tab dmdmartz
/*
    Marital |
     status |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |      4,007       58.58       58.58
          2 |      1,545       22.59       81.17
          3 |      1,288       18.83      100.00
------------+-----------------------------------
      Total |      6,840      100.00
*/

* Insurance Coverage analysis
tab hiq011
/*
 Covered by |
     health |
  insurance |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |      5,800       84.80       84.80
          2 |      1,040       15.20      100.00
------------+-----------------------------------
      Total |      6,840      100.00
*/

/*
                      depression_score
-------------------------------------------------------------
      Percentiles      Smallest
 1%            0              0
 5%            0              0
10%            0              0       Obs               6,840
25%            0              0       Sum of wgt.       6,840

50%            2                      Mean           3.283626
                        Largest       Std. dev.      4.246013
75%            5             26
90%            9             26       Variance       18.02862
95%           12             26       Skewness       1.930759
99%           19             27       Kurtosis       7.204586

*/

* Depression Status analysis
generate status = "Yes" if depression_score >= 10
replace status = "No" if depression_score < 10
tab status
/*
     status |      Freq.     Percent        Cum.
------------+-----------------------------------
         No |      6,220       90.94       90.94
        Yes |        620        9.06      100.00
------------+-----------------------------------
      Total |      6,840      100.00

*/
tab riagendr
tabulate dmdmartz, generate(freq2)



graph bar, over(riagendr) ascategory legend(label(1 "Male") label(2 "Female"))
graph box indfmpir
graph pie, over(dmdeduc2) plabel(_all percent) legend(label(1 "Less than 9th grade") label(2 "9-11th grade") label(3 "High school graduate/GED or equivalent") label(4 "Some college or AA degree") label(5 "College graduate or above"))

tabulate riagendr, generate(freq_gender3)

graph bar, over(status) ascategory


****************************************************************************************************************************
****************************************************************************************************************************
****************************************************************************************************************************
****************************************************************************************************************************
****************************************************************************************************************************
****************************************************************************************************************************
****************************************************************************************************************************
****************************************************************************************************************************
* Part E: CONDUCTING BIVARIABLE ANALYSES
tab riagendr

************************
* Variable Rename
label define gender 1 "Male" 2 "Female"
label values riagendr gender
tab riagendr

label define education_level 1 "Less than 9th grade" 2 "9-11th grade (Includes 12th grade with no diploma)" 3 "High school graduate/GED or equivalent" 4 "Some college or AA degree" 5 "College graduate or above" 7 "Refused" 9 "Don't Know"
label values dmdeduc2 education_level
tab dmdeduc2

label define marital_status 1 "Married/Living with Partner" 2 "Widowed/Divorced/Separated" 3 "Never married" 77 "Refused" 99 "Don't Know"
label values dmdmartz marital_status
tab dmdmartz

gen income_poverty_cat = .

replace income_poverty_cat = 0 if indfmpir < 1

replace income_poverty_cat = 1 if indfmpir >= 1


label define income_poverty_cat_label 0 "smaller than 1" 1 "larger than 1 or equal"
label values income_poverty_cat income_poverty_cat_label
tab income_poverty_cat

************************************************************
* Main Exposure: Continous
************************************************************ 
summarize indfmpir if riagendr == 1, detail
/*

              Ratio of family income to poverty
-------------------------------------------------------------
      Percentiles      Smallest
 1%          .04              0
 5%          .48              0
10%          .74              0       Obs               3,334
25%          1.3              0       Sum of wgt.       3,334

50%          2.4                      Mean           2.711104
                        Largest       Std. dev.      1.619327
75%         4.44              5
90%            5              5       Variance       2.622219
95%            5              5       Skewness       .1888475
99%            5              5       Kurtosis       1.625767


*/
summarize indfmpir if riagendr == 2, detail
/*

              Ratio of family income to poverty
-------------------------------------------------------------
      Percentiles      Smallest
 1%          .04              0
 5%          .36              0
10%          .64              0       Obs               3,506
25%         1.15              0       Sum of wgt.       3,506

50%         2.16                      Mean           2.544113
                        Largest       Std. dev.      1.627801
75%          4.1              5
90%            5              5       Variance       2.649735
95%            5              5       Skewness       .3118261
99%            5              5       Kurtosis       1.694805


*/

* Age
tabstat indfmpir, by(age_category) stat(mean, median)
/*
age_category |      Mean       p50
-------------+--------------------
       19-24 |  2.168996      1.74
       25-44 |  2.551436       2.2
       45-64 |  2.747596      2.45
         65+ |  2.672571      2.31
-------------+--------------------
       Total |  2.625509      2.29
----------------------------------
*/

* Education Level
tabstat indfmpir, by(dmdeduc2) stat(mean, median)
/*

Summary for variables: indfmpir
Group variable: dmdeduc2 (Education level - Adults 20+)

        dmdeduc2 |      Mean       p50
-----------------+--------------------
Less than 9th gr |   1.49105      1.19
9-11th grade (In |  1.615381      1.28
High school grad |  2.092126      1.71
Some college or  |  2.647118      2.37
College graduate |  3.795726      4.59
-----------------+--------------------
           Total |  2.625509      2.29
--------------------------------------
*/

* Marital Status
tabstat indfmpir, by(dmdmartz) stat(mean, median)
/*

Summary for variables: indfmpir
Group variable: dmdmartz (Marital status)

        dmdmartz |      Mean       p50
-----------------+--------------------
Married/Living w |  2.930347      2.72
Widowed/Divorced |  2.208298      1.76
   Never married |  2.177609      1.72
-----------------+--------------------
           Total |  2.625509      2.29
------

*/

* Health Insurance
tabstat indfmpir, by(hiq011) stat(mean, median)
/*

Summary for variables: indfmpir
Group variable: hiq011 (Covered by health insurance)

  hiq011 |      Mean       p50
---------+--------------------
       1 |  2.784786      2.49
       2 |  1.737231      1.44
---------+--------------------
   Total |  2.625509      2.29
------------------------------


*/

* Depression Score
tabstat indfmpir, by(status) stat(mean, median)
/*
status |      Mean       p50
-------+--------------------
    No |  2.694809      2.39
   Yes |  1.930274       1.5
-------+--------------------
 Total |  2.625509      2.29
----------------------------
*/
tab status
anova depression_score income_poverty_cat

ttest indfmpir, by(riagendr)
anova indfmpir age_category
anova indfmpir ridage
anova indfmpir dmdeduc2
pwcorr ridage indfmpir, sig
anova indfmpir dmdmartz
anova indfmpir hiq011
ttest indfmpir, by(status)
pwcorr depression_score indfmpir, sig


************************************************************
* Main Exposure: Categorical
************************************************************ 
tab riagendr income_poverty_cat, chi2 col
pwcorr ridage income_poverty_cat, sig
summarize ridage, detail
summarize ridage if indfmpir < 1, detail
summarize ridage if indfmpir >= 1, detail
tab age_category income_poverty_cat, chi2 col
tab dmdeduc2 income_poverty_cat, chi2 col
tab dmdmartz income_poverty_cat, chi2 col
tab hiq011 income_poverty_cat, chi2 col
pwcorr depression_score income_poverty_cat, sig
tab status income_poverty_cat, chi2 col
summarize depression_score, detail
summarize depression_score if indfmpir < 1, detail
summarize depression_score if indfmpir >= 1, detail


************************************************************
* Main Outcome: Continous
************************************************************ 

tabstat depression_score, by(riagendr) stat(mean, median)
tabstat depression_score, by(age_category) stat(mean, median)
tabstat depression_score, by(dmdeduc2) stat(mean, median)
tabstat depression_score, by(dmdmartz) stat(mean, median)
tabstat depression_score, by(income_poverty_cat) stat(mean, median)
tabstat depression_score, by(hiq011) stat(mean, median)
pwcorr depression_score ridage, sig
tabstat depression_score, by(income_poverty_cat) stat(mean, median)
pwcorr depression_score income_poverty_cat, sig


************************************************************
* Main Outcome: Categorical
************************************************************ 
tab riagendr status, chi2 col
pwcorr ridage income_poverty_cat, sig
tab age_category status, chi2 col
tab dmdeduc2 status, chi2 col
tab dmdmartz status, chi2 col
tab income_poverty_cat status, chi2 col
tab hiq011 status, chi2 col
pwcorr depression_score income_poverty_cat, sig
tab income_poverty_cat status, chi2 col



* Gender
tab riagendr if status == "No"
tab riagendr if status == "Yes"
tab status riagendr, chi2 cell

* Age
summarize ridageyr, detail
summarize ridageyr if status == "No", detail
summarize ridageyr if status == "Yes", detail
ttest ridage, by(status)




tab age_category
/*
. tab age_category

  RECODE of |
   ridageyr |
    (Age in |
   years at |
 screening) |      Freq.     Percent        Cum.
------------+-----------------------------------
      19-24 |        498        7.28        7.28
      25-44 |      2,138       31.26       38.54
      45-64 |      2,504       36.61       75.15
        65+ |      1,700       24.85      100.00
------------+-----------------------------------
      Total |      6,840      100.00


*/
tab age_category if status == "No"
/*
. tab age_category if status == "No"

  RECODE of |
   ridageyr |
    (Age in |
   years at |
 screening) |      Freq.     Percent        Cum.
------------+-----------------------------------
      19-24 |        444        7.14        7.14
      25-44 |      1,953       31.40       38.54
      45-64 |      2,253       36.22       74.76
        65+ |      1,570       25.24      100.00
------------+-----------------------------------
      Total |      6,220      100.00


*/
tab age_category if status == "Yes"
/*
. tab age_category if status == "Yes"

  RECODE of |
   ridageyr |
    (Age in |
   years at |
 screening) |      Freq.     Percent        Cum.
------------+-----------------------------------
      19-24 |         54        8.71        8.71
      25-44 |        185       29.84       38.55
      45-64 |        251       40.48       79.03
        65+ |        130       20.97      100.00
------------+-----------------------------------
      Total |        620      100.00


*/

* Education level
tab dmdeduc2
/*

           Education level - Adults 20+ |      Freq.     Percent        Cum.
----------------------------------------+-----------------------------------
                    Less than 9th grade |        419        6.13        6.13
9-11th grade (Includes 12th grade with  |        721       10.54       16.67
 High school graduate/GED or equivalent |      1,646       24.06       40.73
              Some college or AA degree |      2,318       33.89       74.62
              College graduate or above |      1,736       25.38      100.00
----------------------------------------+-----------------------------------
                                  Total |      6,840      100.00

*/
tab dmdeduc2 if status == "No"
/*

           Education level - Adults 20+ |      Freq.     Percent        Cum.
----------------------------------------+-----------------------------------
                    Less than 9th grade |        370        5.95        5.95
9-11th grade (Includes 12th grade with  |        623       10.02       15.96
 High school graduate/GED or equivalent |      1,469       23.62       39.58
              Some college or AA degree |      2,100       33.76       73.34
              College graduate or above |      1,658       26.66      100.00
----------------------------------------+-----------------------------------
                                  Total |      6,220      100.00


*/
tab dmdeduc2 if status == "Yes"
/*


           Education level - Adults 20+ |      Freq.     Percent        Cum.
----------------------------------------+-----------------------------------
                    Less than 9th grade |         49        7.90        7.90
9-11th grade (Includes 12th grade with  |         98       15.81       23.71
 High school graduate/GED or equivalent |        177       28.55       52.26
              Some college or AA degree |        218       35.16       87.42
              College graduate or above |         78       12.58      100.00
----------------------------------------+-----------------------------------
                                  Total |        620      100.00

. 

*/

* Marital Status
tab dmdmartz
/*

             Marital status |      Freq.     Percent        Cum.
----------------------------+-----------------------------------
Married/Living with Partner |      4,007       58.58       58.58
 Widowed/Divorced/Separated |      1,545       22.59       81.17
              Never married |      1,288       18.83      100.00
----------------------------+-----------------------------------
                      Total |      6,840      100.00


*/
tab dmdmartz if status == "No"
/*

             Marital status |      Freq.     Percent        Cum.
----------------------------+-----------------------------------
Married/Living with Partner |      3,726       59.90       59.90
 Widowed/Divorced/Separated |      1,350       21.70       81.61
              Never married |      1,144       18.39      100.00
----------------------------+-----------------------------------
                      Total |      6,220      100.00


*/
tab dmdmartz if status == "Yes"
/*

             Marital status |      Freq.     Percent        Cum.
----------------------------+-----------------------------------
Married/Living with Partner |        281       45.32       45.32
 Widowed/Divorced/Separated |        195       31.45       76.77
              Never married |        144       23.23      100.00
----------------------------+-----------------------------------
                      Total |        620      100.00

*/

* Ratio of Family Income to Poverty
tab income_poverty_cat
/*

income_pove |
    rty_cat |      Freq.     Percent        Cum.
------------+-----------------------------------
         <1 |      1,264       18.48       18.48
         =1 |         29        0.42       18.90
        >=1 |      5,547       81.10      100.00
------------+-----------------------------------
      Total |      6,840      100.00


*/
tab income_poverty_cat if status == "No"
/*

income_pove |
    rty_cat |      Freq.     Percent        Cum.
------------+-----------------------------------
         <1 |      1,067       17.15       17.15
         =1 |         27        0.43       17.59
        >=1 |      5,126       82.41      100.00
------------+-----------------------------------
      Total |      6,220      100.00


*/
tab income_poverty_cat if status == "Yes"
/*

income_pove |
    rty_cat |      Freq.     Percent        Cum.
------------+-----------------------------------
         <1 |        197       31.77       31.77
         =1 |          2        0.32       32.10
        >=1 |        421       67.90      100.00
------------+-----------------------------------
      Total |        620      100.00


*/

* Health Insurance
tab hiq011
/*

 Covered by |
     health |
  insurance |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |      5,800       84.80       84.80
          2 |      1,040       15.20      100.00
------------+-----------------------------------
      Total |      6,840      100.00

*/
tab hiq011 if status == "No"
/*

 Covered by |
     health |
  insurance |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |      5,283       84.94       84.94
          2 |        937       15.06      100.00
------------+-----------------------------------
      Total |      6,220      100.00

*/
tab hiq011 if status == "Yes"
/*

 Covered by |
     health |
  insurance |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |        517       83.39       83.39
          2 |        103       16.61      100.00
------------+-----------------------------------
      Total |        620      100.00


*/

ttest depression_score, by(riagendr)
pwcorr ridage depression_score, sig
anova depression_score age_category
anova depression_score dmdeduc2
anova depression_score dmdmartz
anova depression_score hiq011
ttest indfmpir, by(status)


****************************************************************************************************************************
****************************************************************************************************************************
****************************************************************************************************************************
****************************************************************************************************************************
****************************************************************************************************************************
****************************************************************************************************************************
****************************************************************************************************************************
****************************************************************************************************************************
* Part G: MULTIVARIABLE ANALYSIS
generate depression_status = 1 if depression_score >= 10
replace depression_status = 0 if depression_score < 10
tab depression_status
codebook depression_status
regress depression_score i.riagendr
regress depression_score i.age_category
regress depression_score i.dmdeduc2
regress depression_score i.dmdmartz
regress depression_score i.hiq011
regress depression_score i.income_poverty_cat
regress depression_status i.income_poverty_cat i.dmdeduc2 i.dmdmartz i.hiq011
regress depression_status i.dmdmartz i.hiq011 i.income_poverty_cat##i.dmdeduc2




logistic depression_status i.riagendr
logistic depression_status i.age_category
logistic depression_status i.income_poverty_cat
logistic depression_status i.dmdeduc2
logistic depression_status i.dmdmartz
logistic depression_status i.hiq011
logistic depression_status i.income_poverty_cat i.dmdeduc2 i.dmdmartz i.hiq011
logistic depression_status i.age_category i.dmdeduc2 i.hiq011 
logistic depression_status i.dmdmartz i.hiq011 i.income_poverty_cat##i.dmdeduc2
