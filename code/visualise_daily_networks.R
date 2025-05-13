library(tidyverse)
library(lubridate)
library(igraph)
library(ggraph)

# Load data
contacts <- read_csv("data/HaslemereProximity.csv")
timeconversion <- read_csv("data/TimeConversion.csv") %>% 
  mutate(day=substr(timestamp,1,3))

# Append a colum to 'contacts' giving the day: 
contacts <- contacts %>% 
  left_join(select(timeconversion, time_step, day), by="time_step")

# Summarise the contacts - keep those closer than 10 meters and flatten by day: 
contacts_summary <- contacts %>% 
  filter(distance_m<10) %>% 
  select(user1_id, user2_id, day) %>% 
  group_by(user1_id, user2_id, day) %>% 
  summarise(duration=n()) %>% 
  mutate(day=factor(day, levels=c("Thu","Fri","Sat"))) %>% 
  arrange(day, user1_id, user2_id) %>% 
  ungroup() 

# Plot the graphs for each day in a list: 
fig_graphs <- contacts_summary %>% 
  split(.$day) %>% 
  map(., ~mutate(., `Hours in contact`=duration/12)) %>% 
  map(., ~(ggraph(., layout="linear", circular=TRUE) + 
    geom_edge_arc(aes(alpha=`Hours in contact`)) +
    geom_node_point(size = .2) + 
    theme_void()))

ggsave(fig_graphs[[1]], file="figures/Thu_network_r.pdf")
ggsave(fig_graphs[[2]], file="figures/Fri_network_r.pdf")
ggsave(fig_graphs[[3]], file="figures/Sat_network_r.pdf")