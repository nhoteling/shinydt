library(shiny)
library(leaflet)
library(ggplot2)
library(DT)



#
# Originally based on example from:
# https://book.javascript-for-r.com/shiny-tips.html
# section 13.2
#
# adjusted according to the example from:
# sdfsdf
#
# customized to npscampr data
#


# Read the data
df.campr1 <- readRDS("data/camping_reservations.rds") %>%
  mutate(dt2 = format.Date(startdate, "%b-%d") %>% as.Date("%b-%d"),
         dt1 = dt2 - window)

df.campr2 <- df.campr1 %>%
  group_by(facility, park, state) %>%
  summarise(numberofpeople = sum(numberofpeople),
            totalpaid = sum(totalpaid),
            window_median = quantile(window,0.5),
            window_upper = quantile(window, 0.25),
            window_lower = quantile(window, 0.75)) 



# Function to create buttons
create_btns <- function(x) {
  x %>%
    purrr::map_chr(~
                     paste0(
                       '<div class = "btn-group">
                   <button class="btn btn-default action-button btn-info action_button" id="view_',
                       .x, '" type="button" onclick=get_id(this.id)><i class="fas fa-edit"></i>View</button>
                   <button class="btn btn-default action-button btn-danger action_button" id="map_',
                       .x, '" type="button" onclick=get_id(this.id)><i class="fa fa-trash-alt"></i>Map</button></div>'
                     ))
}


# Create the buttons, update the df
x <- create_btns(1:nrow(df.campr2))
df.campr3 <- df.campr2 %>%
  tibble::rownames_to_column(var = "Facility") %>%
  dplyr::bind_cols(tibble("Buttons" = x))
