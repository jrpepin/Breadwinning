*need to add n's to results table

use "$tempdir/relearn_year.dta", clear

putexcel set "$results/LifetimeBreadwin.xlsx", sheet(results) modify
putexcel A1="Table 1. Estimates of Breadwinning in first 18 years of Motherhood"
putexcel B2=("Household Earnings") F2=("Couple Earnings")
putexcel B3=("50%") D3=("60%") F3=("50%") H3=("60%") J3=("n")
putexcel A4=("Total")
putexcel A5=("Race-Ethnicity")
putexcel A6=(" Non-Hispanic White")
putexcel A7=(" Black")
putexcel A8=(" Non-Black Hispanic")
putexcel A9=(" Asian")
putexcel A10=(" Other")
putexcel A12=("Educational Attainment")
putexcel A13=(" Less than High School")
putexcel A14=(" High School")
putexcel A15=(" Some College")
putexcel A16=(" College Grad")
putexcel A18=("Marital Status at First Birth")
putexcel A19=(" Not Married")
putexcel A20=(" Married")

* select if started observation a mother or became a mother during observation window
keep if nobsmomminor > 0 

gen negpinc=1 if year_pearn < 0
gen neghinc=1 if year_hearn < 0

* drop cases with negative household income
drop if neghinc==1

sum yearbw50 yearbw60 uyearbw50 uyearbw60 if ageoldest >=0 & ageoldest <=17

*******************************************************************************
* calculate cumulative risk of breadwinning 
*******************************************************************************

keep if ageoldest < 19

*In any given year -- that is, in the cross-section -- the percentage breadwinning is higher with the actual reports and with allocated data and reports.
*But they are less likely to transition into breadwinning with unallocated data. This suggests that the data allocations are introducing random error and
*creating artificial instability. We should limit the analysis to measuring using only unallocated data.

tab ageoldest ubecbw50 if inlist(ubecbw50,0,1), nofreq row 
tab ageoldest ubecbw60 if inlist(ubecbw50,0,1), nofreq row 

*Create dummy indicators for whether woman entered breadwinning between year when oldest child
* is aged a and aged a+1. Note that by limiting analysis to `var' = 0 or 1 (ie. !=2), we are in essence
* dropping cases that were breadwinning in year 1.
* We haven't yet dropped cases that were ever previously observed breadwinning.
* That would probably be best calculated back where we create ybecome_bw50 in create_yearearn.do

preserve

local transition "ubecbw50 ubecbw60"

gen ubw50atbir=uyearbw50 if ageoldest==0
gen ubw60atbir=uyearbw60 if ageoldest==0
	
foreach var in `transition'{
	forvalues a=0/17{
		quietly egen `var'`a'=mean(`var') if ageoldest==`a' & `var' !=2
		tab `var'`a'
	}
}

collapse (max) ubecbw50* ubecbw60* (mean) ubw50atbir ubw60atbir

gen eubecbw50=1-ubw50atbir
gen eubecbw60=1-ubw60atbir  

foreach var in `transition'{
	forvalues a=0/17{
		replace e`var'=(e`var')*(1-`var'`a')
	}
	tab e`var'
}

local bw50=eubecbw50
local bw60=eubecbw60

putexcel B4=(1-`bw50') D4=(1-`bw60')

restore
preserve

keep if my_race==1

local transition "ubecbw50 ubecbw60"

gen ubw50atbir=uyearbw50 if ageoldest==0
gen ubw60atbir=uyearbw60 if ageoldest==0
	
foreach var in `transition'{
	forvalues a=0/17{
		quietly egen `var'`a'=mean(`var') if ageoldest==`a' & `var' !=2
		tab `var'`a'
	}
}

collapse (max) ubecbw50* ubecbw60* (mean) ubw50atbir ubw60atbir

gen eubecbw50=1-ubw50atbir
gen eubecbw60=1-ubw60atbir  

foreach var in `transition'{
	forvalues a=0/17{
		replace e`var'=(e`var')*(1-`var'`a')
	}
	tab e`var'
}

local bw50=eubecbw50
local bw60=eubecbw60

putexcel B6=(1-`bw50') D6=(1-`bw60')

restore
preserve

keep if my_race==2

local transition "ubecbw50 ubecbw60"

gen ubw50atbir=uyearbw50 if ageoldest==0
gen ubw60atbir=uyearbw60 if ageoldest==0
	
foreach var in `transition'{
	forvalues a=0/17{
		quietly egen `var'`a'=mean(`var') if ageoldest==`a' & `var' !=2
		tab `var'`a'
	}
}

collapse (max) ubecbw50* ubecbw60* (mean) ubw50atbir ubw60atbir

gen eubecbw50=1-ubw50atbir
gen eubecbw60=1-ubw60atbir  

foreach var in `transition'{
	forvalues a=0/17{
		replace e`var'=(e`var')*(1-`var'`a')
	}
	tab e`var'
}

local bw50=eubecbw50
local bw60=eubecbw60

putexcel B7=(1-`bw50') D7=(1-`bw60')

restore
preserve

keep if my_race==3

local transition "ubecbw50 ubecbw60"

gen ubw50atbir=uyearbw50 if ageoldest==0
gen ubw60atbir=uyearbw60 if ageoldest==0
	
foreach var in `transition'{
	forvalues a=0/17{
		quietly egen `var'`a'=mean(`var') if ageoldest==`a' & `var' !=2
		tab `var'`a'
	}
}

collapse (max) ubecbw50* ubecbw60* (mean) ubw50atbir ubw60atbir

gen eubecbw50=1-ubw50atbir
gen eubecbw60=1-ubw60atbir  

foreach var in `transition'{
	forvalues a=0/17{
		replace e`var'=(e`var')*(1-`var'`a')
	}
	tab e`var'
}

local bw50=eubecbw50
local bw60=eubecbw60

putexcel B8=(1-`bw50') D8=(1-`bw60')

restore
preserve

keep if my_race==4

local transition "ubecbw50 ubecbw60"

gen ubw50atbir=uyearbw50 if ageoldest==0
gen ubw60atbir=uyearbw60 if ageoldest==0
	
foreach var in `transition'{
	forvalues a=0/17{
		quietly egen `var'`a'=mean(`var') if ageoldest==`a' & `var' !=2
		tab `var'`a'
	}
}

collapse (max) ubecbw50* ubecbw60* (mean) ubw50atbir ubw60atbir

gen eubecbw50=1-ubw50atbir
gen eubecbw60=1-ubw60atbir  

foreach var in `transition'{
	forvalues a=0/17{
		replace e`var'=(e`var')*(1-`var'`a')
	}
	tab e`var'
}

local bw50=eubecbw50
local bw60=eubecbw60

putexcel B9=(1-`bw50') D9=(1-`bw60')

restore
preserve

keep if my_race==5

local transition "ubecbw50 ubecbw60"

gen ubw50atbir=uyearbw50 if ageoldest==0
gen ubw60atbir=uyearbw60 if ageoldest==0
	
foreach var in `transition'{
	forvalues a=0/17{
		quietly egen `var'`a'=mean(`var') if ageoldest==`a' & `var' !=2
		tab `var'`a'
	}
}

collapse (max) ubecbw50* ubecbw60* (mean) ubw50atbir ubw60atbir

gen eubecbw50=1-ubw50atbir
gen eubecbw60=1-ubw60atbir  

foreach var in `transition'{
	forvalues a=0/17{
		replace e`var'=(e`var')*(1-`var'`a')
	}
	tab e`var'
}

local bw50=eubecbw50
local bw60=eubecbw60

putexcel B10=(1-`bw50') D10=(1-`bw60')

restore
preserve

keep if hieduc==1

local transition "ubecbw50 ubecbw60"

gen ubw50atbir=uyearbw50 if ageoldest==0
gen ubw60atbir=uyearbw60 if ageoldest==0
	
foreach var in `transition'{
	forvalues a=0/17{
		quietly egen `var'`a'=mean(`var') if ageoldest==`a' & `var' !=2
		tab `var'`a'
	}
}

collapse (max) ubecbw50* ubecbw60* (mean) ubw50atbir ubw60atbir

gen eubecbw50=1-ubw50atbir
gen eubecbw60=1-ubw60atbir  

foreach var in `transition'{
	forvalues a=0/17{
		replace e`var'=(e`var')*(1-`var'`a')
	}
	tab e`var'
}

local bw50=eubecbw50
local bw60=eubecbw60

putexcel B13=(1-`bw50') D13=(1-`bw60')

restore
preserve

keep if hieduc==2

local transition "ubecbw50 ubecbw60"

gen ubw50atbir=uyearbw50 if ageoldest==0
gen ubw60atbir=uyearbw60 if ageoldest==0
	
foreach var in `transition'{
	forvalues a=0/17{
		quietly egen `var'`a'=mean(`var') if ageoldest==`a' & `var' !=2
		tab `var'`a'
	}
}

collapse (max) ubecbw50* ubecbw60* (mean) ubw50atbir ubw60atbir

gen eubecbw50=1-ubw50atbir
gen eubecbw60=1-ubw60atbir  

foreach var in `transition'{
	forvalues a=0/17{
		replace e`var'=(e`var')*(1-`var'`a')
	}
	tab e`var'
}

local bw50=eubecbw50
local bw60=eubecbw60

putexcel B14=(1-`bw50') D14=(1-`bw60')

restore
preserve

keep if hieduc==3

local transition "ubecbw50 ubecbw60"

gen ubw50atbir=uyearbw50 if ageoldest==0
gen ubw60atbir=uyearbw60 if ageoldest==0
	
foreach var in `transition'{
	forvalues a=0/17{
		quietly egen `var'`a'=mean(`var') if ageoldest==`a' & `var' !=2
		tab `var'`a'
	}
}

collapse (max) ubecbw50* ubecbw60* (mean) ubw50atbir ubw60atbir

gen eubecbw50=1-ubw50atbir
gen eubecbw60=1-ubw60atbir  

foreach var in `transition'{
	forvalues a=0/17{
		replace e`var'=(e`var')*(1-`var'`a')
	}
	tab e`var'
}

local bw50=eubecbw50
local bw60=eubecbw60

putexcel B15=(1-`bw50') D15=(1-`bw60')

restore
preserve

keep if hieduc==4

local transition "ubecbw50 ubecbw60"

gen ubw50atbir=uyearbw50 if ageoldest==0
gen ubw60atbir=uyearbw60 if ageoldest==0
	
foreach var in `transition'{
	forvalues a=0/17{
		quietly egen `var'`a'=mean(`var') if ageoldest==`a' & `var' !=2
		tab `var'`a'
	}
}

collapse (max) ubecbw50* ubecbw60* (mean) ubw50atbir ubw60atbir

gen eubecbw50=1-ubw50atbir
gen eubecbw60=1-ubw60atbir  

foreach var in `transition'{
	forvalues a=0/17{
		replace e`var'=(e`var')*(1-`var'`a')
	}
	tab e`var'
}

local bw50=eubecbw50
local bw60=eubecbw60

putexcel B16=(1-`bw50') D16=(1-`bw60')

restore
preserve

keep if msbirth==0

local transition "ubecbw50 ubecbw60"

gen ubw50atbir=uyearbw50 if ageoldest==0
gen ubw60atbir=uyearbw60 if ageoldest==0
	
foreach var in `transition'{
	forvalues a=0/17{
		quietly egen `var'`a'=mean(`var') if ageoldest==`a' & `var' !=2
		tab `var'`a'
	}
}

collapse (max) ubecbw50* ubecbw60* (mean) ubw50atbir ubw60atbir

gen eubecbw50=1-ubw50atbir
gen eubecbw60=1-ubw60atbir  

foreach var in `transition'{
	forvalues a=0/17{
		replace e`var'=(e`var')*(1-`var'`a')
	}
	tab e`var'
}

local bw50=eubecbw50
local bw60=eubecbw60

putexcel B19=(1-`bw50') D19=(1-`bw60')

restore
preserve

keep if msbirth==1

local transition "ubecbw50 ubecbw60"

gen ubw50atbir=uyearbw50 if ageoldest==0
gen ubw60atbir=uyearbw60 if ageoldest==0
	
foreach var in `transition'{
	forvalues a=0/17{
		quietly egen `var'`a'=mean(`var') if ageoldest==`a' & `var' !=2
		tab `var'`a'
	}
}

collapse (max) ubecbw50* ubecbw60* (mean) ubw50atbir ubw60atbir

gen eubecbw50=1-ubw50atbir
gen eubecbw60=1-ubw60atbir  

foreach var in `transition'{
	forvalues a=0/17{
		replace e`var'=(e`var')*(1-`var'`a')
	}
	tab e`var'
}

local bw50=eubecbw50
local bw60=eubecbw60

putexcel B20=(1-`bw50') D20=(1-`bw60')

restore

tab my_race
tab hieduc
tab msbirth
/*

sort yearspartner

by yearspartner: sum year_pearn year_hearn year_pHHearn [aweight=weight], detail

tab yearspartner yearbw50 [aweight=weight], nofreq row

tab yearspartner yearbw60 [aweight=weight], nofreq row

tab yearage yearbw60 [aweight=weight], nofreq row

tab yearage yearbw60 if yearspartner==1 [aweight=weight], nofreq row

tab yearage yearbw60 if yearspartner==0 [aweight=weight], nofreq row

*
*
*
*
*Percent never breadwinning in first 18 years of motherhood (50%, 60%)
*
*Total .22 .27
*
* Non-Hispanic White .24 .30
* Black .13 .14
* Non-black Hispanic .18 .23
* Asian .32 .36

* Want estimates by educational attainment and marital status at first birth

