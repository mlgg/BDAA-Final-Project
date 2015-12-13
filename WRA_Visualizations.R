###Visualizing Washington State Water Rights Applications for Analysis
install.packages("ggplot2")
library(ggplot2)
install.packages("ggthemes")
library(ggthemes)
install.packages("reshape2")
library(reshape2)
install.packages("plyr")
library(plyr)
install.packages("stats")
library(stats)
install.packages("ggmap")
library(ggmap)
#==============================================================================
#Acquire data
Water_Right_Applications <- read.csv("~/Data Analysis/Data Project/Water_Right_Applications.csv", 
                                     stringsAsFactors=FALSE)

#Isolate data to years 1990-2015, and select desired columns
WRA_base_data <- Water_Right_Applications[which(Water_Right_Applications$YEAR_APPLIED >= 1990),]
WRA_base_data <- WRA_base_data[,c("YEAR_APPLIED", "COUNTY_NAME", 
                                  "PURPOSE_CODE_LIST", "WATERSHED", "SOURCE_NAME", 
                                  "CFS", "GPM", "Latitude1", "Longitude1","Location")]
#============================================================================== 
#Convert CFS to GPM and fill in missing GPMs, then remove CFS column
for(i in 1:length(WRA_base_data$GPM)){
  if(is.na(WRA_base_data$GPM[i] == TRUE)){
     WRA_base_data$GPM[i] <- WRA_base_data$CFS[i]*7.48*60
  }
}
WRA_base_data$CFS <- NULL

#==============================================================================
#Build a key for the purpose codes (with some cleaning)
purpose_code_key <- read.delim("~/Data Analysis/Data Project/Purpose Code Key",
                               stringsAsFactors = FALSE)
purpose_code_key$Code <- gsub(" ","",purpose_code_key$Code)
purpose_code_key$Description <- gsub("\\s*\\([^\\)]+\\)","",as.character(purpose_code_key$Description))
purpose_code_key$Description[2] <- "Com/Ind Manufacturing"
#Add "MULTI" to purpose codes for those situations with multiple uses
purpose_code_key[31,] <- c("MULTI", "Multiple Uses")
#Add "NULL" to purpose codes to allow for complete descriptions
purpose_code_key[32,] <- c("NULL", "No Use Purpose Provided")
#Turn PURPOSE_CODE_LIST to character and rename PURPOSE_CODE
names(WRA_base_data)[names(WRA_base_data)=="PURPOSE_CODE_LIST"] <- "PURPOSE_CODE"
WRA_base_data$PURPOSE_CODE <- gsub(" ","",WRA_base_data$PURPOSE_CODE)

#==============================================================================
#Add purpose descriptions to base data for more complete data set

for (i in 1:length(WRA_base_data$PURPOSE_CODE)) {
    for (j in 1:length(purpose_code_key$Code)) {
        if (WRA_base_data$PURPOSE_CODE[i] == purpose_code_key$Code[j]) {
          WRA_base_data$PURPOSE_DESCRIPTION[i] <- purpose_code_key$Description[j]
        }
    }
}
for(i in 1:length(WRA_base_data$PURPOSE_CODE)){
  if(!(WRA_base_data$PURPOSE_CODE[i] %in% purpose_code_key$Code)){
    WRA_base_data$PURPOSE_CODE[i] <- "MULTI"
    WRA_base_data$PURPOSE_DESCRIPTION[i] <- purpose_code_key$Description[31]
  }
}
#Rearrange columns for more logical organization
WRA_base_data <- WRA_base_data[,c(1,2,3,10,4:9)]
#==============================================================================
#Subset five counties with the most total Water Rights Applications from 1990-2015
per_year_WRA_count_by_county <- count(WRA_base_data, c("YEAR_APPLIED","COUNTY_NAME"))
total_WRA_count_by_county <- aggregate(freq ~ COUNTY_NAME, per_year_WRA_count_by_county, sum)
topsix_WRA_counties <- total_WRA_count_by_county[order(total_WRA_count_by_county$freq, 
                                                        decreasing=TRUE)[1:6],]
WRA_topsix_df <- WRA_base_data[WRA_base_data$COUNTY_NAME %in% 
                                  topsix_WRA_counties$COUNTY_NAME,]

#Barplot showing total water rights applications by couny
counties_barplot <- ggplot(WRA_base_data, aes(x = COUNTY_NAME, fill = ..count..)) + 
  geom_bar() +

  scale_y_continuous(breaks = scales::pretty_breaks(n=10)) +
  
  ggtitle("Total Water Rights Applications per County (1990-2015)") +
  theme(plot.title=element_text(size=16, face="bold", vjust = 2),
        plot.margin=grid::unit(c(1,1,1,1),"cm"),
        plot.background = element_rect(fill = "white")) +
  
  labs(y = "Number of Applications") +
  theme(axis.text.x=element_text(size=14, color = "black", angle = 90, hjust = 1, vjust = 0.5),
        axis.text.y=element_text(size = 10, color = "black"),
        axis.title.x=element_blank(),
        axis.title.y=element_text(size=14, face ="bold", vjust = 1)) +
  
  theme(legend.position="none") +
  
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(colour = "black", fill = NA, size = 1),
        panel.grid.major.y = element_line(colour = "black"),
        panel.grid.minor.y = element_line(colour = "gray"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())

png(filename="County WRAs.png", 
    type="cairo", 
    units="in", 
    width=10, 
    height=8, 
    pointsize=12, 
    res=96)
plot(counties_barplot)
dev.off() 

#Based on prior plot, there are six counties that stand out for having more WRAs than the others
#Plot WRAs for top six counties per year, 1990-2015
WRA_topsix_plotdata <- per_year_WRA_count_by_county[per_year_WRA_count_by_county$COUNTY_NAME %in% 
                                             WRA_topsix_df$COUNTY_NAME,]

topsix_plot <- ggplot(WRA_topsix_plotdata, aes(x = YEAR_APPLIED, y = freq, colour = COUNTY_NAME)) + 
  geom_line(aes(group=COUNTY_NAME), size=1) + 
  
  xlim(1990,2015) +
  
  ggtitle("Water Rights Applications (1990-2015) \n Top Six Counties") +
  theme(plot.title=element_text(size=16, face="bold", vjust = 2),
        plot.margin=grid::unit(c(1,1,1,1),"cm"),
        plot.background = element_rect(fill = "white")) +
  
  labs(x = "Year", y = "Number of Applications") +
  theme(axis.text=element_text(size=14, color = "black"), 
        axis.title.x=element_text(size=14, face="bold", vjust = -0.5),
        axis.title.y=element_text(size=14, face ="bold", vjust = 1)) +
  
  theme(legend.title=element_blank(),
        legend.text = element_text(size = 14, face = "bold"),
        legend.key=element_rect(fill="ivory")) +
  guides(colour = guide_legend(override.aes = list(size=4))) +
  scale_color_brewer(palette="Paired") +
  
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(colour = "black", fill = NA, size = 2),
        panel.grid.major=element_line(colour = "black", size = .5),
        panel.grid.minor = element_line(colour = "gray62", size = .3))

png(filename="Top Six Counties WRAs.png", 
    type="cairo", 
    units="in", 
    width=10, 
    height=8, 
    pointsize=12, 
    res=96)
plot(topsix_plot)
dev.off() 

#==============================================================================
#Plot total counts for purposes, 1990-2015
purposes_barplot <- ggplot(WRA_base_data, aes(x = PURPOSE_DESCRIPTION, fill = ..count..)) + 
  geom_bar() +
  
  scale_y_continuous(breaks = scales::pretty_breaks(n=10)) +
  
  ggtitle("Total Purposes for Water Use (1990-2015)") +
  theme(plot.title=element_text(size=16, face="bold", vjust = 2),
        plot.margin=grid::unit(c(1,1,1,1),"cm"),
        plot.background = element_rect(fill = "white")) +
  
  labs(y = "Number of Applications") +
  theme(axis.text.x=element_text(size=14, color = "black", angle = 90, hjust = 1, vjust = 0.5),
        axis.text.y=element_text(size = 10, color = "black"),
        axis.title.x=element_blank(),
        axis.title.y=element_text(size=14, face ="bold", vjust = 1)) +
  
  theme(legend.position="none") +
  
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(colour = "black", fill = NA, size = 1),
        panel.grid.major.y = element_line(colour = "black"),
        panel.grid.minor.y = element_line(colour = "gray"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())

png(filename="Purpose for WRAs.png", 
    type="cairo", 
    units="in", 
    width=10, 
    height=8, 
    pointsize=12, 
    res=96)
plot(purposes_barplot)
dev.off() 

#There are five purposes that are obviously more common, explore them further
#Subset top five purposes for a Water Rights Application
per_year_purpose_count_by_county <- count(WRA_base_data, 
                                          c("YEAR_APPLIED","COUNTY_NAME",
                                            "PURPOSE_CODE", "PURPOSE_DESCRIPTION"))
total_purpose_count <- aggregate(freq ~ PURPOSE_CODE, 
                                 per_year_purpose_count_by_county, sum)
topfive_purpose <- total_purpose_count[order(total_purpose_count$freq, 
                                             decreasing=TRUE)[1:5],]
purpose_topfive_df <- WRA_base_data[WRA_base_data$PURPOSE_CODE 
                                    %in% topfive_purpose$PURPOSE_CODE,]


#Plot top five county Water Rights Applications, 1990-2015
purpose_topfive_plotdata <- per_year_purpose_count_by_county[
                              per_year_purpose_count_by_county$PURPOSE_CODE 
                              %in% purpose_topfive_df$PURPOSE_CODE,]
topsix_counties_topfive_purposes <-purpose_topfive_plotdata[
                                      purpose_topfive_plotdata$COUNTY_NAME %in% 
                                      WRA_topsix_df$COUNTY_NAME,]

  
#facet-wrapped plot showing breakdown of individual purposes
purpose_facet_plot <- ggplot(per_year_purpose_count_by_county, aes(x=YEAR_APPLIED, y=freq, 
                                             fill=PURPOSE_DESCRIPTION)) + 
  geom_bar(stat="identity") + facet_wrap(~PURPOSE_DESCRIPTION, nrow = 5) +

  ggtitle("Intended Purpose for Water, Count per Year (1990-2015)") +
  theme(plot.title=element_text(size=18, face="bold", vjust = 2),
        plot.margin=grid::unit(c(1,1,1,1),"cm"),
        plot.background = element_rect(fill = "white")) +
  
  labs(x = "Year", y = "Number of Applications") +
  theme(axis.text=element_text(size=14, color = "black"), 
        axis.title.x=element_text(size=14, face="bold", vjust = -0.5),
        axis.title.y=element_text(size=14, face ="bold", vjust = 1)) +
  
  theme(legend.position = "none") +

  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(colour = "black", fill = NA, size = 1),
        panel.grid.major=element_line(colour = "black", size = .5),
        panel.grid.minor = element_line(colour = "gray62", size = .3)) +

  theme(strip.background = element_rect(colour="black", fill="white"))  

png(filename="Purpose Plot.png", 
    type="cairo", 
    units="in", 
    width=12, 
    height=10, 
    pointsize=8, 
    res=100)
plot(purpose_facet_plot)
dev.off() 
  
#plot breaking out top five purposes by top five counties
topfivepurposes_plot <- ggplot(topsix_counties_topfive_purposes, 
                               aes(x=YEAR_APPLIED, y=freq, colour=COUNTY_NAME)) + 
  geom_line(aes(group=COUNTY_NAME), size=1) + 

  facet_wrap(~PURPOSE_DESCRIPTION, nrow = 3, ncol = 2) +
  
  ggtitle("Most Common Water Purposes \n Top Five Counties per Year (1990-2015)") +
  theme(plot.title=element_text(size=18, face="bold", vjust = 2),
        plot.margin=grid::unit(c(1,1,1,1),"cm"),
        plot.background = element_rect(fill = "white")) +
  
  labs(x = "Year", y = "Number of Applications") +
  theme(axis.text=element_text(size=14, color = "black"), 
        axis.title.x=element_text(size=14, face="bold", vjust = -0.5),
        axis.title.y=element_text(size=14, face ="bold", vjust = 1)) +
  
  theme(legend.title=element_blank(),
        legend.text = element_text(size = 14, face = "bold"),
        legend.key=element_rect(fill="ivory")) +
  guides(colour = guide_legend(override.aes = list(size=4))) +
  scale_color_brewer(palette="Paired") +
  
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(colour = "black", fill = NA, size = 1),
        panel.grid.major=element_line(colour = "black", size = .5),
        panel.grid.minor = element_line(colour = "gray62", size = .3)) +
  
  theme(strip.background = element_rect(colour="black", fill="white"))  

png(filename="Top Five Purposes for WRAs.png", 
    type="cairo", 
    units="in", 
    width=10, 
    height=8, 
    pointsize=12, 
    res=96)
plot(topfivepurposes_plot)
dev.off() 

#==============================================================================
#Dot plot of locations of water sources by latitude and longitude
location_dotplot <- qmap('washington state', zoom = 6) + 
  geom_point(data = WRA_base_data, aes(x = Longitude1, y = Latitude1), 
             color="darkred", size=2, alpha=0.5) +
  
  scale_x_continuous( limits = c( -125 , -116.8 ) , expand = c( 0 , 0 ) ) +
  
  scale_y_continuous( limits = c( 45.5 , 49.2 ) , expand = c( 0 , 0 ) ) +
  
  ggtitle("Locations of Water Sources Identified on Applications (1990-2015)") +
  
  theme(plot.title=element_text(size=16, face="bold"),
        plot.margin=grid::unit(c(1,1,1,1),"cm")) +
  
  theme(axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        legend.position="none",
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        plot.background=element_blank())

png(filename="Source Locations.png", 
    type="cairo",
    units="in", 
    width=10, 
    height=8, 
    pointsize=12, 
    res=120)
plot(location_dotplot)
dev.off() 

#Heatmap of Total Applications per County




#==============================================================================
#barplot total for each watershed
watersheds_barplot <- ggplot(WRA_base_data, aes(x = WATERSHED, fill = ..count..)) + 
  geom_bar() +
  
  scale_y_continuous(breaks = scales::pretty_breaks(n=10)) +
  
  ggtitle("Total Applications by Watershed (1990-2015)") +
  theme(plot.title=element_text(size=16, face="bold", vjust = 2),
        plot.margin=grid::unit(c(1,1,1,1),"cm"),
        plot.background = element_rect(fill = "white")) +
  
  labs(y = "Number of Applications") +
  theme(axis.text.x=element_text(size=14, color = "black", angle = 90, hjust = 1, vjust = 0.5),
        axis.text.y=element_text(size = 10, color = "black"),
        axis.title.x=element_blank(),
        axis.title.y=element_text(size=14, face ="bold", vjust = 1)) +
  
  theme(legend.position="none") +
  
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(colour = "black", fill = NA, size = 1),
        panel.grid.major.y = element_line(colour = "black"),
        panel.grid.minor.y = element_line(colour = "gray"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())

png(filename="watersheds count.png", 
    type="cairo", 
    units="in", 
    width=10, 
    height=8, 
    pointsize=12, 
    res=96)
plot(watersheds_barplot)
dev.off() 

#==============================================================================
