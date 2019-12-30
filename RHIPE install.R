# run "sudo apt install libcurl4-openssl-dev" to help with curl install
install.packages("RCurl")
# install protobuf; run "sudo apt-get install protobuf-compiler libprotobuf-dev libprotoc-dev" first
install.packages("RProtoBuf")
# set environment variables
Sys.setenv(HADOOP_HOME="/home/user/Documents/hadoop-3.1.2/")
Sys.setenv(HADOOP_BIN="/home/user/Documents/hadoop-3.1.2/bin")
# run "sudo apt-get install r-cran-rjava" to install rJava since install.packages("rJava") won't work.
# install RHIPE
# ------ currently incompatible with latest protobuf; abort installation -------
system("wget http://ml.stat.purdue.edu/rhipebin/archive/Rhipe_0.71.tar.gz")
install.packages("testthat")
install.packages("Rhipe_0.71.tar.gz", repos=NULL, type="source")
library(Rhipe)
rhinit()
# create bin directory on HDFS
rhmkdir("/user/bin")
hdfs.setwd("/user/bin")
bashRhipeArchive("R.Pkg")
# each time your R code will require the installations on the HDFS, you must in your R session run
library(Rhipe)
rhinit()
rhoptions(zips = "/user/bin/R.Pkg.tar.gz")
rhoptions(runner = "sh ./R.Pkg/library/Rhipe/bin/RhipeMapReduce.sh")


