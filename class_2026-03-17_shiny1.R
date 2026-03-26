library(tidyverse)
library(shiny)
library(bslib)

ui = bslib::page_sidebar(
  title = "Beta-Binomial Visualizer",
  sidebar = bslib::sidebar(
    h4("Data:"),
    sliderInput("y", "# of heads", min=0, max=100, value=7),
    sliderInput("n", "# of flips", min=0, max=100, value=10),
    h4("Prior:"),
    numericInput("a", "Prior # of heads", min=0, max=100, value=1),
    numericInput("b", "Prior # of tails", min=0, max=100, value=1)
  ),
  plotOutput("plot"),
  tableOutput("table")
)

server = function(input, output, session) {
  
  observe({
    print("Hello")
  }) |>
    bindEvent(input$y, ignoreInit = TRUE)
  
  observe({
    updateSliderInput(session, "y", max = input$n)
  })
  
  df = reactive({
    tibble(
      p = seq(0,1, length.out=1001)
    ) |>
      mutate(
        prior = dbeta(p, input$a, input$b),
        likelihood = dbinom(input$y, size = input$n, prob = p) |>
          (\(x) {x/(sum(x) / n())})(),
        posterior = dbeta(p, input$a + input$y, input$b + input$n - input$y)
      ) |>
      pivot_longer(
        cols = -p, names_to = "distribution", values_to = "density"
      ) |>
      mutate(
        distribution = forcats::as_factor(distribution)
      )
  })
  
  output$table = renderTable({
    df() |>
      group_by(distribution) |>
      summarize(
        mean = sum(p * density) / n(),
        median = p[(cumsum(density/n()) >= 0.5)][1],
        q025 = p[(cumsum(density/n()) >= 0.025)][1],
        q975 = p[(cumsum(density/n()) >= 0.975)][1]
      )
  })
  
  
  output$plot = renderPlot({
    ggplot(df(), aes(x=p, y=density, color=distribution)) +
      geom_line() +
      geom_ribbon(aes(ymax=density, fill=distribution), ymin=0, alpha=0.5)
  })
  
}

shinyApp(ui = ui, server = server)
