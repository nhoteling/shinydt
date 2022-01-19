
# Plot the Planning Window
plot_dialog <- function(facility, park) {
  shiny::modalDialog(
    title = "Reservation Window",
    div(
      class = "text-center",
      div(
        style = "display: inline-block;",
        plotOutput("plot", width = "500px")
      )
    ),
    size = "m",
    easyClose = TRUE,
    footer = div(
      class = "pull-right container",
      shiny::actionButton(
        inputId = "dismiss_modal",
        label = "Close",
        class = "btn-danger"
      )
    )
  ) %>% shiny::showModal()
}



# Plot the Leaflet Map
map_dialog <- function(facility, park) {
  shiny::modalDialog(
    title = "Park Location",
    div(
      class = "text-center",
      div(
        style = "display: inline-block;",
        leafletOutput("mymap", width = "500px")
      )
    ),
    size = "m",
    easyClose = TRUE,
    footer = div(
      class = "pull-right container",
      #shiny::actionButton(
      #  inputId = "final_edit",
      #  label = x,
      #  icon = shiny::icon("edit"),
      #  class = "btn-info"
      #),
      shiny::actionButton(
        inputId = "dismiss_modal",
        label = "Close",
        class = "btn-danger"
      )
    )
  ) %>% shiny::showModal()
}