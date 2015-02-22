library(UsingR)

shinyServer(
     function(input, output) {
          output$myPlot <- renderPlot({
               # my data based on slider data 
               dist.data <- seq(60,5280*2, 100) #min = 60, max = 5280*2, step = 100
               
               #Transmission Delay 
               #Message Size (KB)
               Msg.data <- c(50,500,5000)
               
               MsgMB <- Msg.data * 0.001
               sm<-1 #small message index
               med <- 2 #medium message index
               lg <- 3 #large message index
               
               wifiMBps <- input$wifi * 0.125 #convert bits to Bytes
               
               dtrans <- (MsgMB/wifiMBps) * 1000 #convert seconds to ms
               
               #Propagation Delay
               speedOfLight <- 186000 * 5280 # convert to feet per second
               dprop <- (dist.data/speedOfLight) * 1000 # convert to ms
               
               #Processing Delay
               dproc <- 0 #time it takes routers to process packet headers (negligible)
               
               #number of routers 
               Hubs <- input$NR #node range in feet 
               NL <- round(dist.data/Hubs,0) + 1 # the number of nodes we need
               numSensors <- (NL-1)*3 #sensors per node
               
               # calculate Network Delay for each main transaction
               NP1 <- NL * (dtrans[sm] + dprop + dproc) #Sensor Discovery (small message)
               NP2 <- NL * (dtrans[med] + dprop + dproc) #Sensor Health Status (medium message)
               NP3 <- NP1 # Sensor alerts (small message)
               NP4 <- NP1 # Request data from Sensors (small message)
               NP5 <- NL * (dtrans[lg] + dprop + dproc) #Sensor data (large message)
               NP6 <- NP1 # Request additional data from Sensors (small message)
               
               Dtotal <- NP1 + NP2 + NP3 + NP4 + NP5 + NP6
               
               currentDistance <- input$Distance
               
               index <- match(currentDistance,dist.data) #index into vector of selected distance
               
               plot(numSensors,Dtotal/1000, xlab='# Sensors', 
                    ylab="Latency (seconds)", col='lightblue',
                    main='Sensor System WiFi Latency')
	
               lines(c(numSensors[index],numSensors[index]), c(0,300),
                     col="blue",lwd=3)
               
               #calculate placement of text labels
               yTextValue <- round(mean(Dtotal/1000),0)
               xTextValue <- round(max(numSensors)*0.8,0)

               text(xTextValue, yTextValue+10, paste("# Sensors = ", numSensors[index]))
               text(xTextValue,yTextValue, paste("Distance = ", currentDistance, " feet"))
               text(xTextValue, yTextValue-10, paste("Latency = ", round(Dtotal[index]/1000,0)," seconds"))
          })
          
     }
)