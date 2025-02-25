*-------------------------------------------------------------------------------
* BREADWINNER PROJECT - NLSY97 Component
* nlsy97_desriptives.do
* Joanna Pepin and Kelly Raley
*-------------------------------------------------------------------------------

********************************************************************************
* Setup the log file
********************************************************************************
local logdate = string( d(`c(current_date)'), "%dCY.N.D" ) 		// create a macro for the date

local list : dir . files "$logdir\*nlsy97_descriptives_*.log"	// Delete earlier versions of the log
foreach f of local list {
    erase "`f'"
}

log using "$logdir\nlsy97_descriptives_`logdate'.log", t replace

di "$S_DATE"

********************************************************************************
* DESCRIPTION
********************************************************************************
* This file provides basic descriptive information about mothers' income.
* The data used in this file was produced from nlsy97_measures.do

clear
set more off

use "NLSY97_bw.dta", clear

// Count number of respondents
unique 	PUBID_1997

// Make sure the data includes all survey years (1997 - 2017)
fre year

********************************************************************************
* Describe percent breadwinning in the first year
********************************************************************************
// The percent breadwinning (50% threhold) in the first year. (~25%)
	sum hhe50 if time		==0 // Breadwinning in the year of the birth

	gen per_hhe50_atbirth	=100*`r(mean)'
	gen nothhe50_atbirth	=1-`r(mean)'

// The percent breadwinning (60% threhold) in the first year. (~17%)
	sum hhe60 if time		==0 // Breadwinning in the year of the birth

	gen per_hhe60_atbirth	=100*`r(mean)'
	gen nothhe60_atbirth	=1-`r(mean)'

********************************************************************************
* Generate basic descriptives
********************************************************************************
// 50% threshold
tab time 		hhe50, row
tab mar_t1 		hhe50, row
tab age_birth 	hhe50, row

table time mar_t1, statistic(mean hhe50) 		// BW by duration of motherhood & mar_t1
table age_birth mar_t1, statistic(mean hhe50) 	// BW by age at first birth & mar_t1

// 60% threshold
tab time 		hhe60, row
tab mar_t1 		hhe60, row
tab age_birth 	hhe60, row

table time mar_t1, statistic(mean hhe60) 		// BW by duration of motherhood & mar_t1
table age_birth mar_t1, statistic(mean hhe60) 	// BW by age at first birth & mar_t1


// Summary statistics-----------------------------------------------------------
foreach var of varlist momwages mombiz momearn totinc hhe50 hhe60{
	sum `var'
	}

// Summary stats of key vars by time
univar momwages mombiz momearn totinc hhe50 hhe60, by(time)

// Percent of each component
* Note: Some of these are over 1. Looked back at raw data, and they really are impossible proportions.
foreach var of varlist momwages mombiz momearn totinc{
	cap drop 	per_`var'
	gen 		per_`var'= round(`var'/totinc, .1)
}

univar per_momwages per_mombiz per_momearn per_totinc, by(time)

tab PUBID_1997 if per_momwages > 1 & per_momwages < .

foreach var of varlist per_momwages per_mombiz per_momearn per_totinc {
tab time `var'  if `var' <= 1, row
}

log close
