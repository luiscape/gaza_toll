# plotting the data
library(ggplot2)

# loading data
data_plot <- read.csv('data/data.csv')

# standardizing
data_plot$date <- as.Date(data_plot$date)
data_plot$value <- as.numeric(sub(",", "", data_plot$value))

# ploting
plot <- ggplot(data_plot) + theme_bw() + 
    geom_bar(aes(date, value), stat = 'identity') + 
    facet_wrap(~ variable)

# storing plot
ggsave('plot.png', plot)


## correlation plots ##
deaths_in_gaza <- data_plot[data_plot$variable == 'deaths in Gaza', ]
rockets_from_gaza <- data_plot[data_plot$variable == 'rockets launched from Gaza', ]
targets_israel <- data_plot[data_plot$variable == 'targets struck by Israel', ]

# more correlated with the number of deaths in Gaza
cor_plot1 <- ggplot() + theme_bw() +
    geom_point(aes(deaths_in_gaza$value, rockets_from_gaza$value)) +
    geom_smooth(aes(deaths_in_gaza$value, rockets_from_gaza$value))

cor(deaths_in_gaza$value, rockets_from_gaza$value)

# less correlated with the number of rockets from Gaza
cor_plot2 <- ggplot() + theme_bw() +
    geom_point(aes(targets_israel$value, rockets_from_gaza$value)) +
    geom_smooth(aes(targets_israel$value, rockets_from_gaza$value))

cor(targets_israel$value, rockets_from_gaza$value)

ggsave('cor_plot1.png', cor_plot2)
ggsave('cor_plot2.png', cor_plot2)
