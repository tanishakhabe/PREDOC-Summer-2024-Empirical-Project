// Loading in the social_capital_county data. 
import delimited "/Users/tanishakhabe/Desktop/PREDOC Program Summer 2024/Empirical Project/social_capital_county.csv", clear

// Splitting the county_name variable. 
split county_name, parse(",") generate(part)

rename part1 new_county_name
rename part2 state_name

// Adding "County" to the new_county_name variable. 
replace new_county_name = new_county_name + " County"

drop county_name
rename county county_number

save "social_capital_data.dta", replace


// Loading in the cross walk data. 
import excel "/Users/tanishakhabe/Desktop/PREDOC Program Summer 2024/Empirical Project/commuting_zone_names.xls", sheet("Sheet1") firstrow clear

rename CountyFIPS county_number

save "cz_crosswalk_data.dta", replace


// Merging the two data sets.
use "social_capital_data.dta", clear
merge 1:1 county_number using "cz_crosswalk_data"
keep if _merge == 3

save "merged_social_capital_data.dta", replace
