# Author: Melyssa Minto
# Date: 10/20/2020
# tidytuesday submission for 10/20/2020 - Great American Beer Festival data
# source: https://github.com/rfordatascience/tidytuesday/blob/master/data/2020/2020-10-20/readme.md



# Loading packages and data -----------------------------------------------
setwd("~/GitHub/tidytuesday")

# > packages --------------------------------------------------------------
library(tidytuesdayR)
library(tidyverse)
library(maps)
library(gganimate)
library(transformr)

# > reading in data -------------------------------------------------------

# tidy tuesday data
tuesdata <- tidytuesdayR::tt_load('2020-10-20')
beer_awards <- tuesdata$beer_awards

# map data
MainStates <- map_data("state")

# Data Exploration -----------------------------------------------------------

# want to see how many medals each brewery has and where
beer_awards %>% 
  # only looking at NC
  filter(state == "NC") %>% 
  select(medal, city, brewery) %>% 
  group_by(brewery, medal, city) %>% 
  mutate(medal_f = factor(medal, levels = c("Gold", "Silver", "Bronze"))) %>% 
  # #viz
  ggplot(aes(y=brewery, fill=  medal_f )) +
  geom_bar() +
  labs(y="NC Breweries", x= "Number of Medals", fill="Medal")+
  theme_minimal() +
  scale_fill_manual(values = c("Gold" = "#D4AF37", "Silver"= "#C0C0C0", "Bronze"= "#A97142"))+
  ggtitle("NC Beer Awards 1987 - 2020")+
  theme(text = element_text(family = "mono", size = 10),
        plot.background = element_rect(fill = "#FFF8E7", color = "transparent"),
        axis.title = element_text( face="bold"))
  ggsave("plots/2020-10-20_NCAwards.png")


# want to see the medal count by state 
MainStates$state = setNames(state.abb, state.name)[str_to_title(MainStates$region)]
beer_awards %>% 
  select(state, medal, year) %>% 
  group_by(state, year) %>% 
  summarize(n = n()) %>% 
  inner_join(MainStates) %>% 
  ggplot() +
  geom_polygon( data=MainStates, aes(x=long, y=lat, group = group), color="white", fill="grey", alpha=0.5 )+
  geom_polygon( aes(x=long, y=lat, group=group, fill = n), color="white", size = 0.2) +
  ggtitle("number of beer awards per state by year ")+
  geom_text( aes(y=48, x=-80, label=as.character(year)),family='mono', check_overlap = TRUE, size=7, fontface="bold") +
  #animate by year
  transition_states(year,transition_length = 1,state_length = 3) +
  theme_minimal()+
  theme(aspect.ratio = .66,
        text = element_text(family = "mono", size = 10),
        plot.background = element_rect(fill = "#FFF8E7", color = "transparent"),
        axis.title = element_text( face="bold"))
anim_save("plots/2020-10-20_USAwards.gif")





