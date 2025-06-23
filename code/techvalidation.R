# ==============================================================================
# Import packages/read data
# ==============================================================================

library(tidyverse) 

hasdat <- read_csv("data/HaslemereProximity.csv")

# ==============================================================================
# Plot number of edges over time 
# ==============================================================================

nedges50 <- hasdat %>% 
	filter(distance_m <= 50) %>% 
	group_by(time_step) %>% 
	summarise(nedges=n()) %>% 
	mutate(cutoff="50")

nedges20 <- hasdat %>% 
	filter(distance_m <= 20) %>% 
	group_by(time_step) %>% 
	summarise(nedges=n()) %>% 
	mutate(cutoff="20")

nedges5 <- hasdat %>% 
	filter(distance_m <= 5) %>% 
	group_by(time_step) %>% 
	summarise(nedges=n()) %>% 
	mutate(cutoff="5")

fig_nedges <- bind_rows(nedges50, nedges20, nedges5) %>% 
	mutate(cutoff=factor(cutoff, levels=c("5","20","50"))) %>% 
	ggplot() + 
		geom_line(aes(x=time_step, y=nedges, col=cutoff)) + 
		scale_x_continuous(
			breaks=seq(from=1, to=577, by=48), 
			labels=c(rep(c("11pm/7am","11am","3pm","7pm"), 3), "11pm")
			) + 
		labs(x="Time", y="Number of edges") + 
		theme_classic() + 
		theme(text=element_text(size=9), axis.text.x=element_text(angle=90, vjust=0.5, hjust=1)) 

ggsave(fig_nedges, file="figures/nedges.pdf", width=3.2, height=3.2/1.6, units="in")
ggsave(fig_nedges, file="figures/nedges.png", width=3.2, height=3.2/1.6, units="in", dpi=600)

# ==============================================================================
# Plot overall degree distribution
# ==============================================================================

degree_df_prelim <- hasdat %>% 
	filter(distance_m<=5) %>% 
	mutate(day=case_when(
		time_step>=1 & time_step<=192 ~ 1,
		time_step>=193 & time_step<=384 ~ 2,
		time_step>=385 & time_step<=576 ~ 3)) %>% 
	group_by(day, user1_id, user2_id) %>% 
	summarise() %>% 
	pivot_longer(c("user1_id","user2_id"), names_to="null", values_to="user_id") %>% 
	select(-null) %>% 
	group_by(day, user_id) %>% 
	summarise(degree=n()) 

dayuserdf <- tibble(
	day=c(rep(1,469), rep(2,469), rep(3,469)),
	user_id=rep(1:469,3))

degree_df <- left_join(dayuserdf, degree_df_prelim, by=c("day","user_id")) %>% 
	arrange(day, user_id) %>% 
	replace_na(list(degree=0))


fig_degreedist <- degree_df %>% 
	mutate(day=factor(day)) %>% 
	ggplot() + 
		geom_histogram(aes(x=degree), fill="white", col="black", binwidth=1) + 
		facet_wrap(~day, nrow=1) + 
		theme_classic() + 
		theme(text=element_text(size=9))

ggsave(fig_degreedist, file="figures/degreedist.pdf", width=6, height=6/1.6, units="in")
ggsave(fig_degreedist, file="figures/degreedist.png", width=6, height=6/1.6, units="in", dpi=600)
















