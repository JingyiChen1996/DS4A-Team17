R
# packages to load or download and load
pkgs = c("dplyr", "rvest","xml2") # packages names
install.packages(pkgs) # can omit if already installed
inst = lapply(pkgs, library, character.only = TRUE) # load them

#followed the instructions from here: https://www.jishuwen.com/d/2EeL

url <- "https://s3.amazonaws.com/tripdata/"
repo <- url %>% read_html %>% 
  xml_child(1) %>% xml_child(1) %>% xml_find_all(".//key")

# extracting file names between </key>
repo %<>% as_list %>% unlist %>% str_match_all("^.*") %>% unlist

# downloading
setwd("~/Desktop/DS4A/") # YOUR FOLDER where to download
dir.create("import_citibikes") # name of the new folder inside
# Download Files
for(file in repo) {
  download.file(paste0(url,file),destfile = paste0("import_citibikes/",file)) 
}

# errors while downloading
#trying URL 'https://s3.amazonaws.com/tripdata/JC-201708 citibike-tripdata.csv.zip'
#Error in download.file(paste0(url, file), destfile = paste0("import_citibikes/",  : 
#  cannot open URL 'https://s3.amazonaws.com/tripdata/JC-201708 citibike-tripdata.csv.zip'
#In addition: Warning message:
#In download.file(paste0(url, file), destfile = paste0("import_citibikes/",  :
#  cannot open URL 'https://s3.amazonaws.com/tripdata/JC-201708 citibike-tripdata.csv.zip': HTTP status was '505 Unknown Error'

# DOWNLOADED "https://s3.amazonaws.com/tripdata/JC-201708 citibike-tripdata.csv.zip" MANUALLY: both zip and csv
# 201307-201402-citibike-tripdata is the folder with files --> move them later

# Unzip 
for(file in repo) {
  paste0("import_citibikes/",file) %>%
    unzip(exdir = "import_citibikes") %>%
    unlink
}



