# library
library(ggplot2)

# basic graph
p <- ggplot(mtcars, aes(x = wt, y = mpg)) + 
  geom_point()
 
# a data frame with all the annotation info
annotation <- data.frame(
   x = c(2,4.5),
   y = c(20,25),
   label = c("label 1", "label 2")
)

# Add text
p + geom_text(data=annotation, aes( x=x, y=y, label=label),                 , 
           color="orange", 
           size=7 , angle=45, fontface="bold" )

ggsave("test_figure.png")