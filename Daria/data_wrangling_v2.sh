# subsetting and merging data in command line
# go to the folder with the files. mine are unzipped, but we can include unzipping part if needed
# this is for Mac OS
cd /Users/shlyuevd/Dropbox/WORKSHOPS/DS4A/import_citibikes

# will loop through all months for 2016. 
# columns that we want to take: starttime = col #2

# rm merged_2020_all_months.txt


YEAR=2016
touch=${YEAR}_all_months.txt # if you start over, you need to remove this file. We append to this file, without overwriting!
for f in 01 02 03 04 05 06 07 08 09 10 11 12; do
 
 echo -en "currenlty working on $f"
 # removing header, piping to "cut"
 awk '(NR>1)' ${YEAR}${f}-citibike-tripdata.csv | cut -d, -f2 >> ${YEAR}_all_months.txt

done









