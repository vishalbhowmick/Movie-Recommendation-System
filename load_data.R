
library(recommenderlab) 
library(magrittr) 
library(dplyr)
library(reshape2)
setwd("F:/git-proj/Movie-recommendation-system")#set your wd here
library(magrittr) 
library(dplyr)
movie_data <- read.csv("movie.csv")
ratings_data <- read.csv("ratings.csv")

new_movieId <- ratings_data %>% group_by(movieId) %>% 
  summarise(count = n()) %>% 
  filter(count > 50) %>%
  pull(movieId)

new_movies <- movie_data %>% filter(movieId %in% new_movieId)

movie_names <- movie_data %>% 
  filter(movieId %in% new_movieId) %>% pull(title) %>%
  as.character() %>% sort()

ratings_data <- ratings_data %>% filter(movieId %in% new_movieId)
rating_mat <- dcast(ratings_data, userId ~ movieId, value.var = "rating", 
                    na.rm=FALSE)
rating_mat <- as.matrix(rating_mat[,-1]) 
rating_mat <- as(rating_mat, "realRatingMatrix")

rec_mod <- Recommender(rating_mat, method = "UBCF", 
                       param = list(method = "pearson", nn = 40)
                       )
