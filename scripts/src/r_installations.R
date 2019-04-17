#!/usr/bin/Rscript

list.of.packages <- c("argparser","ggplot2", "mzID")

new.packages <- list.of.packages[!(list.of.packages %in% 
                                   installed.packages()[,"Package"])]

if(length(new.packages)>0) {
	install.packages(new.packages)
}


