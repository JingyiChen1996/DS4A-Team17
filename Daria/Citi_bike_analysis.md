Rmarkdown citi bikes analysis
================

## Citi bikes data

Zip archive for all cvs files (up to August 2020):
<https://www.dropbox.com/s/wg4gncn6sx5v82i/import_citibikes.zip?dl=0>
How I scrapped all of them: see extracting\_files.sh (just a text file
with R code)

## Data merging

Will take March-August 2019 and 2020 for now

``` r
# packages to load or download and load
pkgs = c("dplyr","ggplot2","tidyverse","readr","janitor","data.table") # packages names
#install.packages(pkgs) # can omit if already installed
inst = lapply(pkgs, library, character.only = TRUE) # load them
```

Loading selected csv and merging in one dataframe

``` r
#library(readr)
files <- list.files(path = "/Users/shlyuevd/Dropbox/WORKSHOPS/DS4A/import_citibikes",
                    pattern = glob2rx("2019*csv"), 
                    full.names = T)

combined_2019 <- rbindlist(lapply(files, fread))

files <- list.files(path = "/Users/shlyuevd/Dropbox/WORKSHOPS/DS4A/import_citibikes",
                    pattern = glob2rx("2020*csv"), 
                    full.names = T)
combined_2020 <- rbindlist(lapply(files, fread))

combined_2019_2020 <- rbind(combined_2019, combined_2020)
combined_2019_2020_clean <- janitor::clean_names(combined_2019_2020)
saveRDS(combined_2019_2020_clean,"/Users/shlyuevd/Dropbox/WORKSHOPS/DS4A/import_citibikes/tibble_2019_2020_clean.rds")
# saving the CSV
fwrite(combined_2019_2020_clean, "/Users/shlyuevd/Dropbox/combined_2019_2020_clean.csv") 
```

loading RDS with cleaned 2019\_2020 data and subseting based on year
(March-August)

``` r
tbl_2020_clean <- readRDS("/Users/shlyuevd/Dropbox/WORKSHOPS/DS4A/import_citibikes/tibble_2019_2020_clean.rds")

# splitting starting date and time: need it to split 2020 and 2019 data
tbl_2020_clean$startDate <- as.Date(tbl_2020_clean$starttime) 
# do not need time for now
#tbl_2020_clean$startTime <- format(as.POSIXct(tbl_2020_clean$starttime), format = "%H:%M:%S") 

# getting top start stations in March-August 2019 vs 2020
tbl_2019 <- subset(tbl_2020_clean, startDate > as.Date("2019-03-01") & startDate < as.Date("2019-08-31")) %>% 
            select(-tripduration,-starttime,-stoptime,-start_station_id,-end_station_id, -bikeid, -usertype,-birth_year,-gender, -startDate)
saveRDS(tbl_2019,"/Users/shlyuevd/Dropbox/WORKSHOPS/DS4A/import_citibikes/tibble_2019_test_for_map.rds")

tbl_2020 <- subset(tbl_2020_clean, startDate > as.Date("2020-03-01") & startDate < as.Date("2020-08-31")) %>%
            select(-tripduration,-starttime,-stoptime,-start_station_id,-end_station_id, -bikeid, -usertype,-birth_year,-gender, -startDate)
saveRDS(tbl_2020,"/Users/shlyuevd/Dropbox/WORKSHOPS/DS4A/import_citibikes/tibble_2020_test_for_map.rds")
```

Top start station in 2019 and
2020

``` r
tbl_2020 <- readRDS("/Users/shlyuevd/Dropbox/WORKSHOPS/DS4A/import_citibikes/tibble_2020_test_for_map.rds")
tbl_2019 <- readRDS("/Users/shlyuevd/Dropbox/WORKSHOPS/DS4A/import_citibikes/tibble_2019_test_for_map.rds")

tbl_2019 %>% count(start_station_name, sort=TRUE) %>% head(10)
```

    ##                start_station_name     n
    ##  1:         Pershing Square North 86332
    ##  2:            E 17 St & Broadway 67185
    ##  3:               8 Ave & W 31 St 66710
    ##  4:         West St & Chambers St 65418
    ##  5:            Broadway & E 22 St 64711
    ##  6:              12 Ave & W 40 St 63055
    ##  7:            Broadway & E 14 St 62072
    ##  8:            Broadway & W 60 St 60260
    ##  9: Christopher St & Greenwich St 58782
    ## 10:              W 20 St & 11 Ave 55881

``` r
tbl_2020 %>% count(start_station_name, sort=TRUE) %>% head(10)
```

    ##                start_station_name     n
    ##  1:              12 Ave & W 40 St 57927
    ##  2:         West St & Chambers St 55611
    ##  3:               1 Ave & E 68 St 50034
    ##  4:            Broadway & W 60 St 46841
    ##  5:   Pier 40 - Hudson River Park 46503
    ##  6: Christopher St & Greenwich St 43881
    ##  7:               W 21 St & 6 Ave 42474
    ##  8:            E 13 St & Avenue A 39773
    ##  9:            E 17 St & Broadway 39486
    ## 10:        Central Park S & 6 Ave 37923
