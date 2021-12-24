# Author: Melyssa Minto
# Date: 10/27/2020

# tidy tueaday submission: Canadian wind turbines

# https://github.com/rfordatascience/tidytuesday/blob/master/data/2020/2020-10-27/readme.md


# Loading packages & data -------------------------------------------------
library(tidyverse)
library(tidytuesdayR)
library(grid)
library(png)
data <- tidytuesdayR::tt_load('2020-10-27')
turbines = data$`wind-turbine`

# Explore data ------------------------------------------------------------
str(turbines)
summary(turbines)
 

# Viz ---------------------------------------------------------------------

plot_background = readPNG("plots/plains.png")
# plot
turbines %>%  
  group_by(province_territory) %>% 
  summarise(mean_height = mean(hub_height_m), mean_diameter = mean(rotor_diameter_m)) %>% 
  ggplot(aes(x=province_territory, y = mean_height))+
  annotation_custom(rasterGrob(plot_background, 
                               width = unit(1,"npc"), 
                               height = unit(1,"npc")), 
                    -Inf, Inf, -Inf, Inf) +
  geom_col( color = "grey", fill="white", width = 0.2) +
  geom_point(aes(x=province_territory, y = mean_height-1), color = "grey", size=24, shape="\u26CC", stroke=3, position = position_dodge(2))+
  geom_point(color = "white", size=23, shape="\u26CC", stroke=3)+
  geom_label(aes(x=province_territory, y = mean_height+ 11, label = paste0(round(mean_height, 1), " m") ), fill="#1c5505", color ="white", fontface="bold", family="mono")+
  ylim(0,105)+
  labs(y = "avg height (m)", x = "Province/Territory")+
  ggtitle("Average height of windmills in Canada")+
  theme_minimal()+
  theme(text = element_text(family = "mono", size = 12),
        plot.background = element_rect(fill = "#bbe4e9", color = "transparent"),
        axis.title = element_text( face="bold", color="#1c5505"),
        axis.text.x = element_text(angle = 45, hjust = 1, color = "black"))
ggsave("plots/2020-10-27_Windmill.png")


 
