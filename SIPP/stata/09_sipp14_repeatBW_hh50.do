*-------------------------------------------------------------------------------
* BREADWINNER PROJECT - SIPP14 Component
* sipp14_repeatBW_hh50.do
* Kelly Raley and Joanna Pepin
*-------------------------------------------------------------------------------

********************************************************************************
* DESCRIPTION
********************************************************************************
* The purpose of this analysis is to account for repeat bw unobserved in the SIPP
* using the observed bw estimates generated from the NLSY

* This file will only work after breadwinnerNLSY97 AND breadwinnerSIPP14 files
* have been run in the same Stata session.

********************************************************************************
* Calculate the "Repeat BW discount"
********************************************************************************
// Display the macros of censored bw by duraiton from the NLSY analysis
* Note, these macros were generated by 04_nlsy97_bw_estimates_hh50

	di %9.2f $NLSY50_t5
	di %9.2f $NLSY50_t6
	di %9.2f $NLSY50_t7

// Display the macros of censored bw by duraiton from the SIPP analysis
* Note, these macros were generated by 08_sipp14_bw_estimates_hh50

	di %9.2f $SIPP50_t5
	di %9.2f $SIPP50_t6
	di %9.2f $SIPP50_t7
	
// Calculate the ratio of NLSY transition rate to SIPP transition rate for durations 5-7
* A graph of the transition rates shows 5-7 is where the estimates begin to deviate

	di %9.2f $NLSY50_t5/$SIPP50_t5
	di %9.2f $NLSY50_t6/$SIPP50_t6
	di %9.2f $NLSY50_t7/$SIPP50_t7

// Calculate the average ratio for the three years
	global discount50 = (($NLSY50_t5/$SIPP50_t5) + ($NLSY50_t6/$SIPP50_t6) + ($NLSY50_t7/$SIPP50_t7))/3
	di %9.2f $discount50

********************************************************************************
* Apply the "Repeat BW discount" for years 5 - 17
********************************************************************************

* initialize new cumulative measure at birth -----------------------------------
cap drop		notbw50adj_*
	gen 		notbw50adj_0 		= 1 - (.01*$per_bw50_atbirth)
	gen     	notbw50adj_lesshs 	= (1-prop_bw50_atbirth1)
	gen     	notbw50adj_hs      	= (1-prop_bw50_atbirth2)
	gen     	notbw50adj_somecol 	= (1-prop_bw50_atbirth3)
	gen     	notbw50adj_univ   	= (1-prop_bw50_atbirth4)

* the proportion who do not become bw ------------------------------------------

// These stay the same
	forvalues a=1/4 {
		gen notbw50adj_`a'      	= 1 - firstbw50_`a'[1,2]
		gen notbw50adj_lesshs_`a' 	= 1 - firstbw501_`a'[1,2]
		gen notbw50adj_hs_`a' 	   	= 1 - firstbw502_`a'[1,2]
		gen notbw50adj_somecol_`a' 	= 1 - firstbw503_`a'[1,2]
		gen notbw50adj_univ_`a' 	= 1 - firstbw504_`a'[1,2]
	}
	
// These get the repeat bw discount
	forvalues b=5/17 {
		gen notbw50adj_`b' 			= 1 - firstbw50_`b'[1,2] 	* $discount50
		gen notbw50adj_lesshs_`b' 	= 1 - firstbw501_`b'[1,2]	* $discount50
		gen notbw50adj_hs_`b' 	   	= 1 - firstbw502_`b'[1,2]	* $discount50
		gen notbw50adj_somecol_`b' 	= 1 - firstbw503_`b'[1,2]	* $discount50
		gen notbw50adj_univ_`b' 	= 1 - firstbw504_`b'[1,2]	* $discount50		
	}

* Create the total macros (adjusted bw) _---------------------------------------
	global adj_50_0 = .01*$per_bw50_atbirth

	forvalues d=1/4 {
		global adj50_`d' = firstbw50_`d'[1,2]
		forvalues d=5/17 {
			global adj50_`d' = firstbw50_`d'[1,2] * $discount50
		}
	}
	
* Calculate adjusted survival rates --------------------------------------------

cap drop sur_*
	gen  sur_0        	= 	notbw50adj_0
	
	gen  sur_lesshs_0  	=  	notbw50adj_lesshs
	gen  sur_hs_0     	=  	notbw50adj_hs
	gen  sur_somecol_0  = 	notbw50adj_somecol
	gen  sur_univ_0   	=  	notbw50adj_univ

forvalues d=1/17 {
	local lag = `d'-1
	gen sur_`d' 	  	= (sur_`lag')       	* (notbw50adj_`d')
	
	gen sur_lesshs_`d' 	= (sur_lesshs_`lag') 	* (notbw50adj_lesshs_`d')
	gen sur_hs_`d' 		= (sur_hs_`lag')    	* (notbw50adj_hs_`d')
	gen sur_somecol_`d' = (sur_somecol_`lag')	* (notbw50adj_somecol_`d')
	gen sur_univ_`d' 	= (sur_univ_`lag')  	* (notbw50adj_univ_`d')
}

********************************************************************************
* Put results in an excel file
********************************************************************************

// Create Shell
putexcel set "$output/Descriptives50.xlsx", sheet(proportions) modify
putexcel A8 = ("SIPP Adjusted (18 yrs)")

// ADJUSTED BW by age 18
putexcel B8 = (100*(1-sur_17))  			, nformat(number_d2) // Total
putexcel C8 = (100*(1-sur_lesshs_17))  		, nformat(number_d2) // < HS
putexcel D8 = (100*(1-sur_hs_17))  			, nformat(number_d2) // HS
putexcel E8 = (100*(1-sur_somecol_17))  	, nformat(number_d2) // Some col
putexcel F8 = (100*(1-sur_univ_17))  		, nformat(number_d2) // College
