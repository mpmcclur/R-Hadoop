# Google Analytics (GA) data for a particular visitors of a certain website
# data contains 3 variables: date, city, and pagepath

# Mappter code
# identify the type of the script, here is the RScript
#! /usr/bin/env Rscript
# To disable the warning massages to be printed
options(warn=-1)
setwd("Desktop/Google Analytics")
# To initiating the connection to standard input
input <- file("ga-compiled.csv","r")
# extract 3rd and 4th element of city and pagepath
# write to stream as k-v pairs fed to the Reducer
# Running while loop until all the lines are read
while(length(currentLine <- readLines(input, n=1, warn=FALSE)) > 0) {
  # Splitting the line into vectors by "," separator
  fields <- unlist(strsplit(currentLine, ","))
  # Capturing the city and pagePath from fields
  city <- as.character(fields[3])
  pagepath <- as.character(fields[4])
  # Printing both to the standard output
  print(paste(city, pagepath,sep="\t"),stdout())}
# Closing the connection to that input stream
close(input)

# Reducer code
# To identify the type of the script, here is RScript
#! /usr/bin/env Rscript
# Defining the variables with their initial values
city.key <- NA
page.value <- 0.0
# To initiating the connection to standard input
input <- file("ga-compiled.csv","r")
# Running while loop until all the lines are read
while (length(currentLine <- readLines(input, n=1)) > 0) {
  # Splitting the Mapper output line into vectors by tab("\t") separator
  fields <- strsplit(currentLine, "\t")
  # capturing key and value form the fields
  #collecting the first data element from line which is city
  key <- fields[[1]][1]
  # collecting the pagepath value from line
  value <- as.character(fields[[1]][2])}

# setting up key and values
# if block will check whether key attribute is
# initialized or not. If not initialized then it will be # assigned from collected key attribute with value from # mapper output. This is designed to run at initial time.
if (is.na(city.key)) {
  city.key <- key
  page.value <- value
  } else {
  # Once key attributes are set, then will match with the previous key attribute value. If both of them matched then they will combined in to one.
  if (city.key == key) {
    page.value <- c(page.value, value)
    } else {
    # if key attributes are set already but attribute value # is other than previous one then it will emit the store #p agepath values along with associated key attribute value of city,
    page.value <- unique(page.value)
    # printing key and value to standard output
    print(list(city.key, page.value),stdout())
    city.key <- key
    page.value <- value
  }
}
print(list(city.key, page.value), stdout())
# closing the connectionclose(input)

# now that Mapper and Reducer script are produced in R, let's run them in the Hadoop environment
# download Hadoop Streaming, place in appropriate directory, and execute the following:
system(paste("/home/user/Documents/HadoopStreaming",
             "-input /home/user/Desktop/Google Analytics/ga-compiled.csv",
             "-output /home/user/Desktop/Google Analytics/output2",
             "-file /home/user/Documents/hadoop-3.1.2/ga/ga_mapper.R",
             "-mapper ga_mapper.R",
             "-file /home/user/Documents/hadoop-3.1.2/ga/ga_reducer.R",
             "-reducer ga_reducer.R"))






