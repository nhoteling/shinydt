

server <- function(input, output) {

    
    # Reactive Values; update when buttons are pushed
    rv <- shiny::reactiveValues(
        df = df.campr3,
        dt_row = NULL,
        #add_or_edit = NULL,
        edit_button = NULL,
        keep_track_id = nrow(df.campr3) + 1
    )
    
    
    # Render the datatable
    output$table <- renderDT({
        datatable(
            df.campr3 %>% dplyr::select(-numberofpeople, -totalpaid, -window_upper, -window_lower,-Facility),
            colnames=c("Facility", "Park", "State", "Planning Window (days)","Buttons"),
            options = list(
                columnDefs = list(list(className = 'dt-center', targets = 3))
            ),
            escape=FALSE,
            selection="none",
            rownames=FALSE,
            style="bootstrap"
        )
    })

    
    # Look for 'view' button to be pushed
    shiny::observeEvent(input$current_id, {
        shiny::req(!is.null(input$current_id) & stringr::str_detect(input$current_id, pattern = "view"))
        rv$dt_row <- which(stringr::str_detect(rv$df$Buttons, pattern = paste0("\\b", input$current_id, "\\b")))
        df <- rv$df[rv$dt_row, ]
        plot_dialog(facility = df$facility, park = df$park)
        rv$add_or_edit <- NULL
    })
    
    
    # Look for 'Map' button to be pushed
    shiny::observeEvent(input$current_id, {
        shiny::req(!is.null(input$current_id) & stringr::str_detect(input$current_id, pattern = "map"))
        rv$dt_row <- which(stringr::str_detect(rv$df$Buttons, pattern = paste0("\\b", input$current_id, "\\b")))
        df <- rv$df[rv$dt_row, ]
        map_dialog(facility = df$facility, park = df$park)
        rv$add_or_edit <- NULL
    })
    
    
    # Render the plot, based on reactive values
    output$plot <- shiny::renderPlot({
        df.campr1 %>% 
            filter(facility==rv$df$facility[rv$dt_row]) %>% 
            ggplot() + 
            geom_point(aes(x=dt2, y=dt1), alpha=0.5) +
            scale_x_date(limits=c(as.Date("2022-01-01"),as.Date("2022-12-31")), date_labels="%b") +
            scale_y_date(date_labels="%b") +
            labs(title=rv$df$facility[rv$dt_row],
                 subtitle=rv$df$park[rv$dt_row],
                 x="First day of camping", 
                 y="Date reservation was booked") +
            theme_minimal()
    })
    
    
    # Render the map, based on reactive values
    output$mymap <- renderLeaflet({
        leaflet(data = df.campr1 %>% 
                    filter(facility==rv$df$facility[rv$dt_row]) %>%
                    dplyr::select(facility,park,lon,lat) %>%
                    distinct()) %>%
            addTiles() %>%
            addMarkers(~lon, ~lat, popup = ~facility)
    })
    
    
    # Close window when 'Close' button is pressed
    shiny::observeEvent(input$dismiss_modal, {
        shiny::removeModal()
    })
    
    
    output$model <- renderPrint({
        print(input$current_id)
    })
}
