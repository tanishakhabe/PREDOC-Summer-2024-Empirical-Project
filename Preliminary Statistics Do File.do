use "/Users/tanishakhabe/Desktop/PREDOC Program Summer 2024/Empirical Project/final_inventors_sc_oa_data.dta"

// Summarizing the predictor and response variables used in the regressions. 
summarize inventor top5cit ec_county clustering_county support_ratio_county volunteering_rate_county civic_organizations_county emp2000 frac_coll_plus2000 hhinc_mean2000 poor_share2000 share_black2000 share_white2000 share_hisp2000 share_asian2000

// Graph of the social capital measures versus share of inventors. 
binscatter inventor ec_county, name(g1, replace)
binscatter inventor clustering_county, name(g2, replace)
binscatter inventor support_ratio_county, name(g3, replace)
binscatter inventor volunteering_rate_county, name(g4, replace)
binscatter inventor civic_organizations_county, name(g5, replace)
graph combine g1 g2 g3 g4 g5, cols(2) title("Social Capital Measures vs. Share of Inventors from CZ")
graph export binscatter_scm_inventors.png, replace

// Graph of overall household income versus share of inventors. 
twoway (scatter inventor hhinc_mean2000), title("Mean Household Income vs. Share of Inventors from CZ")
graph export scatter_hhincome_inventors.png, replace

// Graph of parent income quintiles versus share of inventors. 
graph bar (mean) inventor_pq_1 (mean) inventor_pq_2 (mean) inventor_pq_3 (mean) inventor_pq_4 (mean) inventor_pq_5, title("Parent Income Quintiles vs. Share of Inventors from CZ")
graph export bar_pincome_quintiles_inventors.png, replace

// Graph of share of each race versus share of inventors. 
twoway (lowess inventor share_black2000) (lowess inventor share_white2000) (lowess inventor share_hisp2000) (lowess inventor share_asian2000), legend(label(1 "Share Black in 2000") label(2 "Share White in 2000") label(3 "Share Hispanic in 2000") label(4 "Share Asian in 2000")) title("Race Share vs. Share of Inventors from CZ")
graph export race_inventors.png, replace



