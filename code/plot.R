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