use "/Users/tanishakhabe/Desktop/PREDOC Program Summer 2024/Empirical Project/final_inventors_sc_oa_data.dta", clear

// Regression #1: All SC measures vs. innovation. 
// Innovationi = β0 + β1× Connectednessi + β2× Clusteringi + β3× Supporti  + β4× Volunteeringi  + β5× Civici +  εi 

* Correlation matrix to determine the association between inventor and the socical capital measures.
corr inventor ec_county clustering_county support_ratio_county volunteering_rate_county civic_organizations_county

reg inventor ec_county clustering_county support_ratio_county volunteering_rate_county civic_organizations_county, robust



// Regression #2: Only the significant SC measures vs. innovation.
// Innovationi = β0 + β1× Connectednessi + β2× Supporti + εi 
reg inventor ec_county support_ratio_county, robust



// Regression #3: Only the significant SC measures & socioeconomic factors vs. innovation. 
// Innovationi = β0 + β1× Connectednessi + β2× Supporti + β3× Educationi + β4× Incomei  + β5× Employmenti  + β6× Povertyi +  εi
reg inventor ec_county support_ratio_county frac_coll_plus2000 hhinc_mean2000 emp2000 poor_share2000, robust



// Regression #4: Only the significant SC measures, socioeconomic factors & demographic factors vs. innovation. The demographic factors did not end up being significant, so we ended up disregarding this regression.
// Innovationi = β0 + β1× Connectednessi + β2× Supporti + β3× Educationi + β4× Incomei  + β5× Employmenti  + β6× Povertyi + β7× Whitei  + β8× Blacki + β9× Hispanici + β10× Asiani+  εi 
reg inventor ec_county support_ratio_county frac_coll_plus2000 hhinc_mean2000 emp2000 poor_share2000 share_asian2000 share_black2000 share_hisp2000 share_white2000, robust 



// Regression #5: Only the significant SC measures & socioeconomic factors vs. female innovation. Used to compare to Regression #3 of all inventors. 
// Innovation_Fi = β0 + β1× Connectednessi + β2× Supporti + β3× Educationi + β4× Incomei  + β5× Employmenti  + β6× Povertyi + εi 
reg inventor_g_f ec_county support_ratio_county frac_coll_plus2000 hhinc_mean2000 emp2000 poor_share2000, robust



// Regression #6a: Only the significant SC measures & socioeconomic factors vs. innovation rate of parents in the TOP income quintile. 
// Innovation_Topi = β0 + β1× Connectednessi + β2× Supporti + β3× Educationi + β4× Incomei  + β5× Employmenti  + β6× Povertyi + εi 

// Regression #6b: Only the significant SC measures & socioeconomic factors vs. innovation rate of parents in the BOTTOM income quintile. 
// Innovation_Bottomi = β0 + β1× Connectednessi + β2× Supporti + β3× Educationi + β4× Incomei  + β5× Employmenti  + β6× Povertyi + εi 
// Create quintiles of parent income
ssc install coefplot

xtile parent_income_quintile = hhinc_mean2000, nquantiles(5)

// Generate dummy variables for top and bottom quintiles
gen top_quintile = (parent_income_quintile == 5)
gen bottom_quintile = (parent_income_quintile == 1)

// Regression for top quintile
reg inventor ec_county support_ratio_county frac_coll_plus2000 hhinc_mean2000 emp2000 poor_share2000 if top_quintile == 1, robust

// Store results for top quintile
estimates store top_quintile_results

// Regression for bottom quintile
reg inventor ec_county support_ratio_county frac_coll_plus2000 hhinc_mean2000 emp2000 poor_share2000 if bottom_quintile == 1, robust

// Store results for bottom quintile
estimates store bottom_quintile_results

// Display results side by side
estimates table top_quintile_results bottom_quintile_results, b(%9.3f) se(%9.3f) stats(N r2)

// Creating a coefficient plot to visualize the differences
coefplot top_quintile_results bottom_quintile_results, drop(_cons) xline(0) title("Regression Coefficients: Top vs Bottom Quintile") 
graph export top_bottom_quintile_comparison.png, replace


// Scatter plot of economic connectedness vs. innovation by parent income quintiles. 
twoway (scatter inventor ec_county if top_quintile==1, mcolor(blue)) ///
       (scatter inventor ec_county if bottom_quintile==1, mcolor(red)), ///
       legend(order(1 "Top Quintile of Parent Income" 2 "Bottom Quintile of Parent Income")) ///
       title("Economic Connected vs. Innovation by Parent Income in CZ") ///
       xtitle("Economic Connectedness") ytitle("Share of Inventors from CZ")
graph export ec_income_quintiles_inventors.png, replace


// Regression #7: Only the significant SC measures & socioeconomic factors vs. top5cit of inventors. 
// Innovation_Top5i = β0 + β1× Connectednessi + β2× Supporti + β3× Educationi + β4× Incomei  + β5× Employmenti  + β6× Povertyi + εi 
 
// Create and label variable that converts top5cit variable to "per Thousand" unit of measure
generate top5cit_thousand=top5cit*1000
label variable top5cit_thousand "Children with Total Citations in Top 5% per Thousand"

// Derive summary statistics of top5cit variable
sum top5cit_thousand, detail

// Regress top5cit variable
regress top5cit_thousand ec_county support_ratio_county frac_coll_plus2000 hhinc_mean2000 emp2000 poor_share2000, robust

// Create histogram of top5cit per Thousand variable
histogram top5cit_thousand, fraction bins(12) xlabel(0.1(0.1)1.251565) title("Top 5% Inventors per Thousand")
graph export hist_top5cit.png, replace

// Graph scatterplot of economic connectedness vs. top5cit per Thousand
twoway (scatter top5cit_thousand ec_county), title("Economic Connectedness vs. Top 5% Inventors") xtitle("Mean Economic Connectedness over CZ") ytitle("Children with Total Citations in Top 5% per Thousand")
graph export scatter_ec_top5cit.png, replace

// Graph binned scatterplot of economic connectedness vs. top5cit per Thousand
binscatter top5cit_thousand ec_county, title("Economic Connectedness vs. Top 5% Inventors") xtitle("Mean Economic Connectedness over CZ") ytitle("Children with Total Citations in Top 5% per Thousand")
graph export binned_ec_top5cit.png, replace

// Find top 10 commuting zones with highest shares of children in top 5%
ssc install extremes
extremes top5cit_thousand par_czname, n(10)

// Create label for top 10 commuting zones
gen par_czname2 = par_czname if strpos(par_czname,"Oak Bluffs")
replace par_czname2 = par_czname if strpos(par_czname,"Beloit")
replace par_czname2 = par_czname if strpos(par_czname,"St. Marys")
replace par_czname2 = par_czname if strpos(par_czname,"Brookings")
replace par_czname2 = par_czname if strpos(par_czname,"Hastings")
replace par_czname2 = par_czname if strpos(par_czname,"Perryton")
replace par_czname2 = par_czname if strpos(par_czname,"Sweetwater")
replace par_czname2 = par_czname if strpos(par_czname,"Aberdeen")
replace par_czname2 = par_czname if strpos(par_czname,"Snyder")
replace par_czname2 = par_czname if regexm(par_czname,"York")
replace par_czname2 = "" if strpos(par_czname, "New York")

// Graph scatterplot with top 10 commuting zones labelled
scatter top5cit_thousand ec_county, title("Economic Connectedness vs. Top 5% Inventors") xtitle("Mean Economic Connectedness over CZ") ytitle("Children with Total Citations in Top 5% per Thousand") mlabel(par_czname2) mlabcolor(gs8)
graph export scatter_ec_top5cit_labeled.png, replace
