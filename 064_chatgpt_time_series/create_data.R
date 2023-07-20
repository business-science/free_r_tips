

df <- tibble(
    date  = seq(as.Date("2021-04-01"), as.Date("2023-04-01"), by = "day"),
    value = sin(1:731/(29*2)) + rnorm(731)/10
)
df %>% plot_time_series(date, value)


df %>% write_csv("064_chatgpt_time_series/data/time_series.csv")
