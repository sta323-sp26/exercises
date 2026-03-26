library(tidyverse)
library(shiny)
library(bslib)

ui = page_sidebar(
  theme = bs_theme("darkly"),
  title = "Beta-Binomial Visualizer",
  sidebar = sidebar(
    h4("Data:"),
    sliderInput("x", "# of heads", min=0, max=100, value=7),
    sliderInput("n", "# of flips", min=0, max=100, value=10),
    h4("Prior:"),
    numericInput("alpha", "Prior # of head", min=0, value=5),
    numericInput("beta", "Prior # of tails", min=0, value=5),
  ),
  card(
    card_header("Distributions"),
    card_body(
      plotOutput("plot")    
    ),
    full_screen = TRUE
  ),
  card(
    card_header(
      textOutput("distribution"),
      popover(
        bsicons::bs_icon("gear"),
        title = "Settings",
        selectInput("summary_dist", "Distribution:", choices = c("prior", "likelihood", "posterior"))
      ),
      class = "d-flex justify-content-between align-items-center"
    ),
    card_body(
      uiOutput("value_boxes")
    ),
    height = "250px"
  )
  
)

server = function(input, output, session) {
  
  output$distribution = renderText({
    stringr::str_to_title(input$summary_dist) |> 
      paste("- Summary Statistics")
  })
  
  observe({
    updateSliderInput(session, "x", max = input$n)
  }) |>
    bindEvent(input$n)
  
  d = reactive({
    tibble(
      p = seq(0, 1, length.out = 1000)
    ) |>
      mutate(
        prior = dbeta(p, input$alpha, input$beta),
        likelihood = dbinom(input$x, size = input$n, prob = p) |>
          (\(x) {x / (sum(x) / n())})(),
        posterior = dbeta(p, input$alpha + input$x, input$beta + input$n - input$x)
      ) |>
      pivot_longer(
        cols = -p,
        names_to = "distribution",
        values_to = "density"
      ) |>
      mutate(
        distribution = forcats::as_factor(distribution)
      )
  })
  
  output$plot = renderPlot({      
    ggplot(d(), aes(x=p, y=density, color=distribution)) +
      geom_line(linewidth=1.5) +
      geom_ribbon(aes(ymax=density, fill=distribution), ymin=0, alpha=0.5)
  })
  
  output$value_boxes = renderUI({
    
    stat_icons = list(
      Mean = bsicons::bs_icon("bullseye"),
      Median = bsicons::bs_icon("distribute-horizontal"),
      `CI 95%` = bsicons::bs_icon("arrows-expand-vertical")
    )
    
    dist_colors = c(
      prior = "danger",
      likelihood = "success",
      posterior = "primary"
    )
    
    stats = d() |>
      group_by(distribution) |>
      summarize(
        mean = sum(p * density) / n(),
        median = p[(cumsum(density/n()) >= 0.5)][1],
        q025 = p[(cumsum(density/n()) >= 0.025)][1],
        q975 = p[(cumsum(density/n()) >= 0.975)][1]
      ) |>
      filter(
        distribution == input$summary_dist
      )
    
    layout_column_wrap(
      width = 1/3,
      value_box(
        title = "Mean",
        showcase = bsicons::bs_icon("bullseye"),
        value = stats |> pull(mean) |> head(1) |> round(3),
        theme = dist_colors[input$summary_dist]
      ),
      value_box(
        title = "Median",
        showcase = bsicons::bs_icon("distribute-horizontal"),
        value = stats |> pull(median) |> head(1) |> round(3),
        theme = dist_colors[input$summary_dist]
      ),
      value_box(
        title = "95% CI",
        showcase = bsicons::bs_icon("arrows-expand-vertical"),
        value = c(stats |> pull(q025) |> head(1),
                  stats |> pull(q975) |> head(1)) |>
          round(3) |>        
          paste(collapse=" - "),
        theme = dist_colors[input$summary_dist]
      )
    )
  })
}

shinyApp(ui = ui, server = server)
