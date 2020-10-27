**All RACES + ALL YEARS
insheet using [DRIVE/raw-polls.csv", clear

gen act_trump_margin=cand2_actual-cand1_actual
gen pred_trump_margin=cand2_pct-cand1_pct
gen pred_clinton_margin=cand1_pct-cand2_pct
gen act_clinton_margin=cand1_actual-cand2_actual

gen margin_error_favor_trump=pred_trump_margin-act_trump_margin
gen margin_error_favor_clinton=pred_clinton_margin-act_clinton_margin

gen abs_margin_error=abs(pred_trump_margin-act_trump_margin)
label var abs_margin_error "Absolute value error on margin of second candidate's loss or win"

gen error_trump=abs(cand2_pct-cand2_actual)
gen error_clinton=abs(cand1_pct-cand1_actual)
egen point_est_error=rowmean(error_clinton error_trump)
label var point_est_error "Mean of absolute value error on percentage point estimates for top two candidates"

**This metric considers that each race varies in difficulty & ///
**adjusts observed error from mean error for the specific race

*First count number of polls per race
bysort race_id: egen Num_Polls=count(abs_margin_error)

foreach x in point_est_error margin_error_favor_trump abs_margin_error  error  rightcall{
bysort race_id: egen M`x'=mean(`x')
bysort race_id: gen ADJ`x'=`x'-M`x'
replace ADJ`x'=. if Num_Polls<=1
}

*Merge grade from other 538 data
merge m:1 pollster using pollster-stats-full.dta"
drop _merge

*Collapse by pollster
collapse (first) grade score (count) N=abs_margin_error (mean) ADJpoint_est_error ADJmargin_error_favor_trump ADJabs_margin_error ADJrightcall ADJerror  point_est_error margin_error_favor_trump margin_poll margin_actual abs_margin_error bias Mpoint_est_error Mmargin_error_favor_trump Mabs_margin_error rightcall, by(pollster)
label var score "Encoded letter grade 1-15 scale"

*Remove polls with less than 10 runs
drop if N<10
foreach x in ADJpoint_est_error ADJmargin_error_favor_trump ADJabs_margin_error ADJerror  point_est_error margin_error_favor_trump abs_margin_error bias {
egen R`x'=rank(`x'), track
}

foreach x in ADJrightcall rightcall {
egen R`x'=rank(`x'), field
}

sort ADJpoint_est_error
edit

reg ADJpoint_est_error score 
reg ADJabs_margin_error score 
cor score  ADJabs_margin_error ADJpoint_est_error ADJrightcall abs_margin_error point_est_error rightcall

di .43*.5
di .08*.5

egen Overall_Rank=rowmean(RADJabs_margin_error RADJpoint_est_error)

foreach x in Overall_Rank  {
egen R`x'=rank(`x'), track
}

sort ROverall_Rank
label var ROverall_Rank "Rank on both errors outcomes"

*insert your preferred location
outsheet using \Pollster_Rankings_All_Years.csv", replace

**2016 ONLY***
*insert your preferred location

**2016 Presidential Election
insheet using [DRIVE/raw-polls.csv", clear

keep if type_simple=="Pres-G" 
keep if year==2016

gen act_trump_margin=cand2_actual-cand1_actual
gen pred_trump_margin=cand2_pct-cand1_pct
gen pred_clinton_margin=cand1_pct-cand2_pct
gen act_clinton_margin=cand1_actual-cand2_actual

gen margin_error_favor_trump=pred_trump_margin-act_trump_margin
gen margin_error_favor_clinton=pred_clinton_margin-act_clinton_margin

gen abs_margin_error=abs(pred_trump_margin-act_trump_margin)
label var abs_margin_error "Absolute value error on margin of second candidate's loss or win"

gen error_trump=abs(cand2_pct-cand2_actual)
gen error_clinton=abs(cand1_pct-cand1_actual)
egen point_est_error=rowmean(error_clinton error_trump)
label var point_est_error "Mean of absolute value error on percentage point estimates for top two candidates"

**This metric considers that each race varies in difficulty & ///
**adjusts observed error from mean error for the specific race

*First count number of polls per race
bysort race_id: egen Num_Polls=count(abs_margin_error)

foreach x in point_est_error margin_error_favor_trump abs_margin_error  error  rightcall{
bysort race_id: egen M`x'=mean(`x')
bysort race_id: gen ADJ`x'=`x'-M`x'
replace ADJ`x'=. if Num_Polls<=1
}

*Merge grade from other 538 data//change drive location
merge m:1 pollster using pollster-stats-full.dta"
drop _merge

*Collapse by pollster
collapse (first) grade score (count) N=abs_margin_error (mean) ADJpoint_est_error ADJmargin_error_favor_trump ADJabs_margin_error ADJrightcall ADJerror  point_est_error margin_error_favor_trump margin_poll margin_actual abs_margin_error bias Mpoint_est_error Mmargin_error_favor_trump Mabs_margin_error rightcall, by(pollster)
label var score "Encoded letter grade 1-15 scale"

**Average margin of error per poll in favor Trump (-3.4), meaning average poll had 3.4 ppt Clinton bias
sum margin_error_favor_trump [aw=N]

*Remove polls with less than 5 runs
drop if N<2
foreach x in ADJpoint_est_error ADJmargin_error_favor_trump ADJabs_margin_error ADJerror  point_est_error margin_error_favor_trump abs_margin_error bias {
egen R`x'=rank(`x'), track
}

foreach x in ADJrightcall rightcall {
egen R`x'=rank(`x'), field
}

sort ADJpoint_est_error
edit

reg ADJpoint_est_error score 
reg ADJabs_margin_error score 
cor score  ADJabs_margin_error ADJpoint_est_error ADJrightcall abs_margin_error point_est_error rightcall

di .43*.5
di .08*.5

egen Overall_Rank=rowmean(RADJabs_margin_error RADJpoint_est_error RADJrightcall)

sort Overall_Rank
foreach x in Overall_Rank  {
egen R`x'=rank(`x'), track
}

sort ROverall_Rank
label var ROverall_Rank "Rank on both errors outcomes"


outsheet using \Pollster_Rankings_2016.csv", replace

**2016 Election by STATE
insheet using "\raw-polls_2020_538.csv", clear

keep if type_simple=="Pres-G" 
keep if year==2016

gen act_trump_margin=cand2_actual-cand1_actual
gen pred_trump_margin=cand2_pct-cand1_pct
gen pred_clinton_margin=cand1_pct-cand2_pct
gen act_clinton_margin=cand1_actual-cand2_actual

gen margin_error_favor_trump=pred_trump_margin-act_trump_margin
gen margin_error_favor_clinton=pred_clinton_margin-act_clinton_margin

gen abs_margin_error=abs(pred_trump_margin-act_trump_margin)
label var abs_margin_error "Absolute value error on margin of second candidate's loss or win"

gen error_trump=abs(cand2_pct-cand2_actual)
gen error_clinton=abs(cand1_pct-cand1_actual)
egen point_est_error=rowmean(error_clinton error_trump)
label var point_est_error "Mean of absolute value error on percentage point estimates for top two candidates"

**This metric considers that each race varies in difficulty & ///
**adjusts observed error from mean error for the specific race

*First count number of polls per race
bysort race_id: egen Num_Polls=count(abs_margin_error)

foreach x in point_est_error margin_error_favor_trump abs_margin_error  error  rightcall{
bysort race_id: egen M`x'=mean(`x')
bysort race_id: gen ADJ`x'=`x'-M`x'
replace ADJ`x'=. if Num_Polls<=1
}

*Merge grade from other 538 data
merge m:1 pollster using "X:\Franklin_Templeton\CONSULTING\External_Data\pollster-stats-full.dta"
drop _merge

*Collapse by pollster
collapse (first) grade score (count) N=abs_margin_error (mean) ADJpoint_est_error ADJmargin_error_favor_trump ADJabs_margin_error ADJrightcall ADJerror  point_est_error margin_error_favor_trump margin_poll margin_actual abs_margin_error bias Mpoint_est_error Mmargin_error_favor_trump Mabs_margin_error rightcall, by(pollster location)

**Average margin of error per poll in favor Trump (-3.4), meaning average poll had 3.4 ppt Clinton bias
sum margin_error_favor_trump [aw=N]

foreach x in ADJpoint_est_error ADJmargin_error_favor_trump ADJabs_margin_error ADJerror  point_est_error margin_error_favor_trump abs_margin_error bias {
egen R`x'=rank(`x'), track
}

foreach x in ADJrightcall rightcall {
egen R`x'=rank(`x'), field
}

sort ADJpoint_est_error
edit

reg ADJpoint_est_error score 
reg ADJabs_margin_error score 
cor score  ADJabs_margin_error ADJpoint_est_error ADJrightcall abs_margin_error point_est_error rightcall

egen Overall_Rank=rowmean(RADJabs_margin_error RADJpoint_est_error RADJrightcall)

sort Overall_Rank
foreach x in Overall_Rank  {
egen R`x'=rank(`x'), track
}

sort ROverall_Rank
label var ROverall_Rank "Rank on both errors outcomes"

outsheet using "Pollster_Rankings_2016_by_State.csv", replace c
