navbarPage(
  # Application title
  title=div(img(src="logo4.png", alt="PropSight", height=20)),
  windowTitle="PropSight - Property at a glance",
  
  # Landing Page
  tabPanel(
    "Home",
    
    # Jumbotron
    tags$div(
      class="jumbotron",
      style="background-color: transparent;",
      
      fixedRow(
        # Left column
        column(7,
          style="padding: 50px;",
          
          tags$h1(
           class="display-1",
           style="color: #385A64;",
           "PropSight"
          ),
          tags$p(
            style="font-size: 18px;",
           "— Property at a glance"
          ),
          tags$p(
            "PropSight is your virtual property surveyor that helps you to ",
            "find the property of your dreams ",
            icon("heart", class="text-danger", lib = "font-awesome")
          ),
          actionButton(
            "get_started",
            "Get Started",
            class="btn btn-primary btn-lg",
          )
        ),
        
        # Right column
        column(5,
          tags$img(
           src="house-search.jpg",
           width="100%",
           style="margin-right: 50px;"
          )
        )
        
      ) 
    )
  ),
  
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
        
        h2("Choose view:"),
        selectInput("selected_view", "Select view", g_option_view),
        # add a submit button here,
        # looks like the submit button in wordcloud tab disabled reactivity.
        submitButton('Submit')
      ),
      
      # If not using custom CSS, set height of leafletOutput to a number instead of percent
      div(
        leafletOutput("map", width = "70%", height = "100%"),
        style = "height: 95%; padding: 2em; overflow-y: auto;"
      )
    )
  ), 
  tabPanel(
    "User Guide",
    class = "container",
    bootstrapPage(
      sidebarLayout(
        sidebarPanel(
          titlePanel("Who should use this app?"),
          tags$ol(
            tags$li("First time home buyers looking for potential property units"), 
            tags$li("Property investors looking for area with high-yield returns"), 
            tags$li("Property developers scouting for new strategic areas of development")
          ),
          class = "bg-success"
        ),
        mainPanel(
          tags$h2("How to use this app?"),
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
    bootstrapPage(
      div(
        DT::dataTableOutput("rawDataTable"),
        style = "height: 100%; padding: 15px; overflow-y: auto;"
      )
    )
  ), 
  tabPanel(
    "Processed Data",
    class = "outer",
    bootstrapPage(
      div(
        DT::dataTableOutput("processedDataTable"),
        style = "height: 100%; padding: 15px; overflow-y: auto;"
      )
    )
  ),
  tabPanel(
    "Forum Post Analysis",
    class = "outer",
    bootstrapPage(
      div(
        style = "height: 100%; padding: 15px; overflow-y: auto",
        
        # Input wrapper
        div(
          proptalkURL,
          textInput("topicUrl", 'Choose a Topic URL : ', value = '', width = NULL,
                placeholder = NULL),
      
          numericInput("lastPost", 'Last Post # : ', 100, min = 10, max = 1000, step = 20,
                   width = NULL),
          submitButton('Submit')
        ),
      
        # Output wrapper
        div(
          style = "margin-top: 30px;",
          
        
          # display the Topic Title here.
          h2(textOutput("topicTitle"), style = "text-align: center; margin-bottom: 15px;"),
      
          # render the wordcloud2 here.
          wordcloud2::wordcloud2Output('wc2')
        )
      )
    )
  ),
  tabPanel(
    "About Project",
    class = "container",
    bootstrapPage(
      tags$div(
        tags$div(
          tags$div(
            tags$h2("Data Science Workflows", class = 'text-primary'),
            tags$ol(
              tags$li("Data Sourcing"), 
              tags$ol(
                tags$li("Property Listings in Kuala Lumpur from https://www.kaggle.com/dragonduck/property-listings-in-kuala-lumpur"), 
                tags$li("Kuala Lumpur GeoJSON from https://github.com/TindakMalaysia/Federal-Territories-Maps/blob/master/KL/2016/MAP/MIGRATED/result/09-WPKL-New-DM-4326.geojson"), 
                tags$li("Kuala Lumpur OGR Shapefile from https://extract.bbbike.org"), 
              ),
              tags$li("Data Processing"),
              tags$ol(
                tags$li("Property Listings data is combined with the GeoJSON data to form the geo-boundaries around the property area"), 
                tags$li("Once the geo-boundaries are displayed in the Shiny app, we overlay the OGR data (Point of Interests) on top of the map"), 
              ),
              tags$li("Deployment of Shiny application to shinyapps.io"),
            )
          ),
          tags$div(
            tags$h2("Dataset Description", class = 'text-success'),
            tags$ol(
              tags$li("Property Listing in Kuala Lumpur"),
              tags$ul(
                tags$li("Location, Price, Room, Bathrooms, Car Parks, Property Type, Size, Furnishing"),
                tags$li("53,883 entries"),
              ),
              tags$li("Kuala Lumpur GeoJSON"),
              tags$ul(
                tags$li("Location, DUN"),
              ),
              tags$li("Kuala Lumpur OGR Shapefile"),
              tags$ul(
                tags$li("Points"),
                tags$li("Railways"),
              ),
            ),
          ),
          tags$div(
            tags$h2("Team Experience", class = 'text-secondary'),
            tags$ol(
              tags$li("We are able to work collaboratively using Github, Google Drive, Microsoft team, and Whatsapp"), 
              tags$li("Teamwork is key so we discuss frequently to push progress"), 
            )
          )
        )
      )
    )
  ) 
)