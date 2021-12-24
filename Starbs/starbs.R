
# Load Libraries ----------------------------------------------------------
library(tidyverse)
library(forcats)
library(ggtext)
# Get the data ------------------------------------------------------------
starbucks <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-12-21/starbucks.csv')

size_labels = c(short = "<img src='short.png' align='bottom' width='30'/><br>Short",
                tall = "<img src='tall.png' align='bottom' width='30'/><br> Tall",
                grande = "<img src='grande.png' align='bottom' width='33'/><br> Grande",
                venti = "<img src='venti.png' align='bottom' width='37'/> <br> Venti")
# explore data --------------------------------------------------------------

starbucks %>% 
  mutate(drink_type = case_when( grepl("Chocolate", product_name) ~ "Hot Chocolate",
                                 grepl("Chai", product_name) ~ "Chai",
                                 TRUE ~ "Coffee")
         ) %>% 
  filter(drink_type %in% "Chai") %>% 
  mutate(size = fct_relevel(size, c("short", "tall","grande", "venti"))) %>% 
  filter(size %in% c("short", "tall","grande" ,"venti")) %>% 
  filter(milk == 5) %>%
  filter(whip == 0) %>% 
  filter(!grepl("Tea", product_name, ignore.case = T)) %>% 
  filter(!grepl("Roast", product_name, ignore.case = T)) %>% 
  mutate(product_name = fct_reorder(product_name, calories)) %>% 
  select(product_name, size, calories, caffeine_mg) %>% 
  group_by(product_name) %>% 
  arrange(size, .by_group = T) %>% 
  mutate(delta_calorie = (calories - lag(calories, default = first(calories)))/first(calories) ,
         delta_caffiene = (caffeine_mg - lag(caffeine_mg, default = first(caffeine_mg)))/first(caffeine_mg) ) %>% 
  ungroup() %>% 
  ggplot(aes(x = size, y= delta_calorie)) +
  geom_point(aes(color = "#166332"), size = 3) +
  geom_point(aes(x = size, y = delta_caffiene,color = "#453829")) +
  scale_color_manual(values = c( "#166332", "#453829"), labels = c("calories", "caffiene"), name = "")+
  scale_x_discrete(name = NULL, labels = size_labels)+
  geom_line(aes(x = delta_calorie, y = delta_caffiene, group = size))+
  geom_segment(aes(x = size, y = delta_calorie, xend = size, yend = delta_caffiene))+
  facet_wrap(~product_name, ncol = 1)+
  theme_minimal() +
  theme(axis.text.x = element_markdown(color = "black", size = 11, lineheight = 1.2),
        plot.title = element_markdown(face = "bold", color = "#166332", hjust = 0.5))+
  ggtitle("Is The Venti _Worth_ It?") +
  labs(  y = "Percent Change") 

 ggsave("VentiorNah.png")
