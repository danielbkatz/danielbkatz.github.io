reg_data <- matrix(data=NA, nrow=300, ncol=102)
rm(j)

x <- runif(100)

m <- 0
for(j in 1:3){
  for(i in 1:100){
    m <- m+1
    reg_data[m,1] <- m

    reg_data[m,2] <- j

  reg_data[m, 3:102] <- rnorm(n = 100, mean = j)

  }
}

library(tidyverse)

library(gganimate)
reg_data <- as.data.frame(reg_data) %>%
  pivot_longer(., cols = V3:V102)



library(gganimate)

reg_data1 <- reg_data %>%
  filter(V2==1)


p <- ggplot(data=reg_data1, aes(x=V2, y=value)) + geom_point()
p

anim <- p + transition_states(V1,
                              transition_length = 2,
                              state_length = 1)



reg_list <- list ()

k <-0
n <- 100
for(i in 1:200){
beta <- .8
reg_list[[i]] <- data.frame(num= i, x =runif(n, 0, 5)) %>%
  mutate(y = rnorm(n, beta*x, 1))
}



reg_dat <- do.call(rbind, reg_list)

sm <- (lm(y ~ x, data=reg_dat[reg_dat$num==3, ]))
summary(sm)
int <- sm$residuals

p2 <- reg_dat %>%
  group_by(num) %>%
  mutate(int=(lm(y ~ x)[[1]][[1]]),
         slope=lm(y ~ x)[[1]][[2]],
         resid = lm(y ~ x)$residuals) %>%
  ggplot(aes(x=x, y=y)) +
  geom_point() +
  geom_abline( aes(intercept=int, slope=slope)) +
  transition_states(num) +
  shadow_mark( exclude_layer = 1, past =T, future=F, color="grey")

p2


View(reg_dat)

summary(reg_dat)

p3 <- reg_dat %>%
  group_by(num) %>%
  mutate(int=(lm(y ~ x)[[1]][[1]]),
         slope=lm(y ~ x)[[1]][[2]],
         resid = lm(y ~ x)$residuals) %>%
  ggplot(aes(x=resid)) + geom_histogram(binwidth = .05) +
  transition_states(num)

p3


reg_list2 <- list ()

k <-0
n <- 100
for(i in 1:100){
  beta <- .8
  reg_list2[[i]] <- data.frame(num= i, x =runif(n, 0, 5)) %>%
    mutate(y = rpois(n, beta*x))
}



reg_dat2 <- do.call(rbind, reg_list2)


glmp <- glm(data = reg_dat2[reg_dat2$num==1, ], y~x, family = "poisson")

summary(glmp)



p_pois <- reg_dat2 %>%
  group_by(num) %>%
  mutate(int=(glm(y ~ x)[[1]][[1]]),
         slope=glm(y ~ x)[[1]][[2]],
         resid = glm(y ~ x)$residuals) %>%
  ggplot(aes(x=x, y=y)) +
  geom_point() +
  geom_abline( aes(intercept=int, slope=slope)) +
  transition_states(num) +
  shadow_mark( exclude_layer = 1, past =T, future=F, color="grey")

p_pois


phist_p <- reg_dat2 %>%
  group_by(num) %>%
  mutate(int=(lm(y ~ x)[[1]][[1]]),
         slope=lm(y ~ x)[[1]][[2]],
         resid = lm(y ~ x)$residuals) %>%
  ggplot(aes(x=resid)) + geom_histogram(binwidth = .05) +
  transition_states(num)
phist_p
