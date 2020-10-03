# subsetting and merging data in command line
# go to the folder with the files. mine are unzipped, but we can include unzipping part if needed
cd /Users/shlyuevd/Dropbox/WORKSHOPS/DS4A/import_citibikes

# will loop through all months for 2020. 
# columns that we want to create: keep year and the month and sum of rides for each stations id
# to come back to station names and coordinates we can later create a look up table
# for forecasting we need to use stations 
# that existed for quite some years (the most popular) and still exist in 2020

# rm merged_2020_all_months.txt

start=$SECONDS # to measure time it takes

touch=merged_2020_all_months.txt # if need to remove if you start over. We append to this file, without overwriting
for f in 202001 202002 202003 202004 202005 202006 202007 202008; do
  # creating month in YYYY-MM-DD; but can it make to look the way you like
  month=$(echo $f | awk -v F=${f} '{print substr($0,1,4)"-"substr($0,5,6)"-01"}')
  # removing the header, and keeping only stations ID. Uniq -c: first column = number of occurences; second = station ID
  awk '(NR>1)' ${f}-citibike-tripdata.csv | cut -d, -f4 | sort -k1,1 | uniq -c | \
  awk -v MONTH=${month} -v OFS="\t" '{print MONTH,$2,$1}' >> merged_2020_all_months.txt
done

end=$SECONDS
duration=$(( end - start ))
echo "script took $duration seconds to complete" #script took 246 seconds to complete

# the resulting merged_2020_all_months.txt (119K) has MONTH, stattion_id, number of times in that month the station was used as a start station

# can zip the file
zip merged_2020_all_months.zip merged_2020_all_months.txt

############################### if files are zipped: 
touch=merged_2020_all_months.txt # if need to remove if you start over. We append to this file, without overwriting
for f in 202001 202002 202003 202004 202005 202006 202007 202008; do
  # creating month in YYYY-MM-DD; but can it make to look the way you like
  month=$(echo $f | awk -v F=${f} '{print substr($0,1,4)"-"substr($0,5,6)"-01"}')
  # removing the header, and keeping only stations ID. Uniq -c: first column = number of occurences; second = station ID
  unzip ${f}-citibike-tripdata.zip | awk '(NR>1)'  | cut -d, -f4 | sort -k1,1 | uniq -c | \
  awk -v MONTH=${month} -v OFS="\t" '{print MONTH,$2,$1}' >> merged_2020_all_months.txt
done



