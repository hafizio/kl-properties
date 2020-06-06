navbarPage(
  
  # Application title
  "Kuala Lumpur Properties Price",
  
  tabPanel(
    "Interactive Map",
    div(
      class = "outer",
      tags$head(
        includeCSS("styles.css")
      ),
      absolutePanel(
        id = "controls",
        class = "panel panel-default",
        fixed = TRUE,
        draggable = FALSE,
        top = 55,
        left = "auto",
        right = 10,
        bottom = "auto",
        width = "30%",
        height = "100%",
        
        h2("Choose something:"),
        selectInput("selected_view", "Select view", g_option_view)
      ),
      
      # If not using custom CSS, set height of leafletOutput to a number instead of percent
      leafletOutput("map", width = "70%", height = "100%")
      
  
    )
  ), 
  tabPanel(
    "User Guide",
    class = "outer",
    # TODO : fix the css, so that scrollable when displaying more rows.
    tags$head(tags$style( type = 'text/css',  'table { overflow-y: scroll; height: 500px; }')),
    bootstrapPage(
      titlePanel("Welcome to our app!"),
      sidebarLayout(
        sidebarPanel(
          titlePanel("Who should use this app?"),
          tags$ol(
            tags$li("First time home buyers looking for potential property units"), 
            tags$li("Property investors looking for area with high-yield returns"), 
            tags$li("Property developers scouting for new strategic areas of development")
          )
        ),
        mainPanel(
          titlePanel("How to use this app?"),
          tags$ol(
            tags$li("Click the Interactive Map tab"), 
            tags$li("Choose to view areas either by Property Price or Per Square Fee (psq)"),
            tags$li("The map will show area heat map based on the selected option"),
            tags$li("Hover your web cursor on the area of interest to see more details"),
            tags$li("Hover your web cursor to the stacks icon on top right of the map to select any Point of Interests (POIs)"),
            tags$li("Once the POIs legends are selected, it'll show additional markers on the map"),
            tags$li("To further see the sentiment of a particular area, the user can click Forum Post Analysis tab"),
            tags$li("In the Forum Post Analysis page, the user can key in the lowyat.net topic ID for analysis"),
            tags$li("The lowyat.net topic ID represents a forum discussion specific for that a particular area e.g Sentul Village ID is 4001664"),
            tags$li("The system would then crawl the forum site and gather the sentiments of the discussion and create a wordcloud to the user the see"),
            tags$li("Based on all of these information, the user would be able to make a preliminary decision on which area is of interest to him/her"),
          )
        )
      )
    )
  ), 
  tabPanel(
    "Raw Data",
    class = "outer",
    # TODO : fix the css, so that scrollable when displaying more rows.
    tags$head(tags$style( type = 'text/css',  'table { overflow-y: scroll; height: 500px; }')),
    bootstrapPage(
      DT::dataTableOutput("rawDataTable")
    )
  ), 
  tabPanel(
    "Processed Data",
    class = "outer",
    # TODO : fix the css, so that scrollable when displaying more rows.
    tags$head(tags$style( type = 'text/css',  'table { overflow-y: scroll; height: 500px; }')),
    bootstrapPage(
      DT::dataTableOutput("processedDataTable")
    )
  ),
  tabPanel(
    "Forum Post Analysis",
    class = "outer",
    # TODO : fix the css, so that scrollable when displaying more rows.
    tags$head(tags$style( type = 'text/css',  'table { overflow-y: scroll; height: 500px; }')),
    bootstrapPage(
      textInput("topicUrl", 'Topic URL (lowyat.net) only : ', value = 'https://forum.lowyat.net/topic/4001664', width = NULL,
                placeholder = NULL),
      
      numericInput("lastPost", 'Last Post # : ', 100, min = 10, max = 1000, step = 20,
                   width = NULL),
      submitButton('Submit'),
      
      # display the Topic Title here.
      # TODO : proper alignment so that look nicer
      textOutput("topicTitle"),
      
      # render the wordcloud2 here.
      wordcloud2::wordcloud2Output('wc2')
    )
  )
  
)