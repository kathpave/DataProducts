shinyUI(pageWithSidebar(
     headerPanel("WiFi Latency"),
     
     sidebarPanel(        
          sliderInput('Distance', 'Surveillance Area (feet); 10,560 feet = 2 miles',value = 760, 
                      min = 60, max = 5280*2, step = 100), 
          sliderInput("NR", "Average Network Hub Range (feet); Unobstructive range is 200 feet", 
                       value = 100, min = 25, max = 200, step=25), 
          sliderInput('wifi', 'Average WiFi throughput (Mbps-Megabits per second)',
                      value = 45, min = 30, max = 100, step = 5),
          helpText("Latency is determined by Network Delay for each major network transaction (ND for T1) = Nodes*(Transmission Delay + Propagation Delay + Processing Delay)")
     ),
     mainPanel(
          helpText("This application calculates the WiFi Latency for a 
                   surveillance sensor network based on 3 sensors per node 
                   (Alert Sensor and 2 Confirming Sensors). User selects the 
                   surveillance area (up to 2 miles), node range, and 
                   expected WiFi throughput.  The total Latency is calculated 
                   based on execution of 6 main network transactions of varying
                   message sizes."),
          
          plotOutput('myPlot')
     )
))