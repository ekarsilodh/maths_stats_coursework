#Q1
#simulation the mc game
mc_sims <- function() {
  pos <- 0                #initialize start at base of mountain i.e. 0
  turns <- 0              #counter to store no. of turns taken to finish
  
  #run the game till position 70 not reached
  while (pos < 70) {
    pos <- play_mc(pos)   #perform the markov chain sim for a single turn and its corresponding transition
    turns <- turns + 1.   #increase counter for each transition
  }
  
  return(turns)           #total turns taken to reach position 70 i.e. summit
}

#---------------------------------------------------------------------------------------------------

#Q2
#function to simulate a complete Mountain Climb game
play_mc_full <- function(
    start_pos = 0,                            #starting position (default = 0), base of mountain
    max_turns = 500,                          #safety cap on no. of turns
    slippery_squares = seq(9, 63, by = 9),    #default: multiples of 9 upto 63, denoting slippery squares
    climbing_squares = seq(16, 64, by = 16),  #default: multiples of 16 upto 64, denoting climbing squares
    slip_back_range = 1:3,                    #default: player slides back by 1, 2 or 3 positions on slippery squares
    climb_up_amount = 5,                      #default: player climbs +5 positions on climbing squares
    max_pos = 70                              #default: summit position (game ends here)
) {
  #initialize current position
  pos <- start_pos   
  
  #track full position history including starting position
  pos_history <- c(pos)              
  
  #turn counter
  turns <- 0
  
  #continue the game until reaching or exceeding the summit i.e. max_pos or max_turns
  while (pos < max_pos && turns < max_turns) {
    #roll die & move
    die <- sample.int(6, 1)       #roll fair 6-sided die
    pos <- pos + die              #move forward by die result
    
    #-----Apply the special rules if the player haven't reached the summit-----
    if (pos < max_pos) {
      
      #-----Slippery squares; i.e. player lands on multiple of 9-----
      if (pos %in% slippery_squares) {
        slide <- sample(slip_back_range, 1)       #uniformly choose slip amount
        pos <- pos - slide                        #slides back uniformly by random 1-3 spaces
        pos <- max(pos, 0)                        #avoid negative position if pos < slide
      }
      
      #-----Climbing squares; i.e. player lands on multiple of 16-----
      if (pos %in% climbing_squares) {
        pos <- pos + climb_up_amount              #jumps 5 positions
      }
      
      #-----Cap at max_pos (absorbing state)-----
      if (pos > max_pos) {
        pos <- max_pos
      }
    }
    
    #-----One turn completed-----
    turns <- turns + 1
    #print(turns)
    
    #store updated pos in history
    pos_history <- c(pos_history, pos)
  }
  
  #-----Return a list with full path and number of turns taken-----
  return(
    list(
      pos_history = pos_history,
      turns_taken = turns
    )
  )
}
  
#---------------------------------------------------------------------------------------------------

#Q3
#function to simulate multiple Mountain Climb games and summarise the results
simulate_climbs <- function(
  n_simulations = 100,                      #number of games to simulate
  start_pos = 0,                            #starting position of the player in each independent game
  max_turns = 500,                          #safety cap on no. of turns
  slippery_squares = seq(9, 63, by = 9),    #default: multiples of 9 upto 63, denoting slippery squares
  climbing_squares = seq(16, 64, by = 16),  #default: multiples of 16 upto 64, denoting climbing squares
  slip_back_range = 1:3,                    #default: player slides back by 1, 2 or 3 positions on slippery squares
  climb_up_amount = 5,                      #default: player climbs +5 positions on climbing squares
  max_pos = 70                              #default: summit position (game ends here)
) {
  
  #numeric vector to store the no. of turns taken in each simulation
  turns_vector <- numeric(n_simulations)
  
  #list for storing position history of each game
  all_histories <- vector("list", n_simulations)
  
  #run simulations
  for (i in seq_len(n_simulations)) {
    #run a complete mountain climb game with all the parameters
    game_result <- play_mc_full(
      start_pos = start_pos,
      max_turns = max_turns,
      slippery_squares = slippery_squares,
      climbing_squares = climbing_squares,
      slip_back_range = slip_back_range,
      climb_up_amount = climb_up_amount,
      max_pos = max_pos
    )
    
    #saving the no. of turns required
    turns_vector[i] <- game_result$turns_taken
    
    #saving the positions visited
    all_histories[[i]] <- game_result$pos_history
  }
  
  #-----Summary statistics for no. of turns taken-----
  turns_stats <- c(
    mean = mean(turns_vector),             #avg no. of turns
    median = median(turns_vector),         #middle value
    sd = sd(turns_vector)                  #standard deviation, value spread
  )
  
  #-----Return as a single list-----
  return(
    list(
      turns_vector = turns_vector,    #no. of turns for each simulation
      turns_stats = turns_stats,      #summary stats of turns
      all_histories = all_histories   #position visited in all simulations
    )
  )
}


#---------------------------------------------------------------------------------------------------

#Q4
#function to simulate multiple Mountain Climb games and summarise the results
simulate_pos_at <- function(
    n_simulations = 100,                      #number of games to simulate
    n_turns = 10,                             #default: fixed turns after which game stops
    start_pos = 0,                            #starting position of the player in each independent game
    max_turns = 500,                          #safety cap on no. of turns
    slippery_squares = seq(9, 63, by = 9),    #default: multiples of 9 upto 63, denoting slippery squares
    climbing_squares = seq(16, 64, by = 16),  #default: multiples of 16 upto 64, denoting climbing squares
    slip_back_range = 1:3,                    #default: player slides back by 1, 2 or 3 positions on slippery squares
    climb_up_amount = 5,                      #default: player climbs +5 positions on climbing squares
    max_pos = 70                              #default: summit position (game ends here)
) {
  
  #numeric vector to store the position after n_turns
  pos_vector <- numeric(n_simulations)
  
  #list for storing position history of each game
  all_histories <- vector("list", n_simulations)
  
  #run simulations
  for (i in seq_len(n_simulations)) {
    pos <- start_pos                                #reset position at start of each simulation
    pos_history <- c(pos)                           #store all the positions visited
    
    #simulate exactly the mentioned no. of turns
    for (t in seq_len(n_turns)) {
      #if summit not reached
      if (pos < max_pos) {
        die <- sample.int(6, 1)                     #roll a fair six-sided die
        pos <- pos + die                            #move forward by the die roll
        
        #-----Slippery squares; i.e. player lands on multiple of 9-----
        if (pos %in% slippery_squares) {
          slide <- sample(slip_back_range, 1)       #uniformly choose slip amount
          pos <- pos - slide                        #slides back uniformly by random 1-3 spaces
          pos <- max(pos, 0)                        #avoid negative position if pos < slide
        }
        
        #-----Climbing squares; i.e. player lands on multiple of 16-----
        if (pos %in% climbing_squares) {
          pos <- pos + climb_up_amount              #jumps 5 positions
        }
        
        #-----Cap at max_pos (absorbing state)-----
        if (pos > max_pos) {
          pos <- max_pos
        }
      }
      
      if (pos >= max_pos) {
        pos <- max_pos
      }
      
      #store tha pasitions visited
      pos_history <- c(pos_history, pos)
    }
    
    #position after n_turns
    pos_vector[i] <- pos
    
    #saving the positions visited
    all_histories[[i]] <- pos_history
  }
  
  #-----Return summary statistics as a single list-----
  return(
    list(
      positions = pos_vector,  # Final position after 'turns' in each simulation
      mean = mean(pos_vector), # Average position reached after 'turns' turns
      variance = var(pos_vector) # Variance of positions (spread of outcomes)
    )
  )
}

#---------------------------------------------------------------------------------------------------

#Q6
#Function for Updating BMI and Removing Outliers
update_bmi <- function(data) {
  #copy of data
  data_modified <- as.data.frame(data)
  
  #recalculating BMI and storing corrected value in a new column bmi_correct
  #weight in kg and height in cm
  #height converted to m for consistency with the standard BMI formula
  data_modified$bmi_correct <- 
    data_modified$weight / ((data_modified$height / 100)^2)
  
  #creating a new dataframe for downstream PCA with cleaned data
  data_clean <- data_modified %>% 
    select(-idx, -bmi) %>%   #remove the old bmi, idx, sex column
    rename(bmi = bmi_correct) %>%  #rename bmi_correct to bmi
    relocate(bmi, .after = 2)  #move the new bmi col to original place
  
  #remove rows with missing, inf, or NA values and keep numeric only
  data_clean_new <- data_clean %>% 
                    select(-sex)
  data_clean_numeric <- data_clean_new[complete.cases(data_clean_new), ]
  
  #performing PCA
  pca_res <- prcomp(data_clean_numeric, 
                    center = TRUE, 
                    scale = TRUE)
  
  #PC1 and PC2 scores for each observation as dataframe for further plotting
  scores <- as.data.frame(pca_res$x[, 1:2])
  #changing col names
  colnames(scores) <- c("PC1", "PC2")
  
  #distances from the PCA origin for each sample
  #scores are scaled before computing squared Euclidean distance for comparability
  pca_res_dist <- rowSums(scale(scores)^2)
  #adding the distances
  scores$dist <- pca_res_dist
  
  #defining outliers using the 97.5% quantile distance threshold 
  outlier_cutoff <- quantile(pca_res_dist, 0.975)
  
  #flagging outliers (logical flag)
  scores$outlier <- pca_res_dist > outlier_cutoff
  
  #groundings for outliers
  scores$type <- ifelse(scores$outlier, "Outlier", "Non-outlier")
  scores$type <- factor(scores$type, levels = c("Non-outlier", "Outlier"))
  
  #identify the rows indices of the data points used for PCA 
  pca_rows <- which(complete.cases(data_clean))
  
  #lookup table linking row index to outlier/type
  outlier_info <- tibble(
    row_id  = pca_rows,
    outlier = scores$outlier,
    type    = scores$type
  )
  
  #join back to data_clean and drop outliers
  data_clean_final <- data_clean %>%
    mutate(row_id = row_number()) %>%
    left_join(outlier_info, by = "row_id") %>%
                                                #keep rows that are either:
                                                #not in PCA (NA outlier), or
                                                #in PCA but not flagged as outlier
    filter(is.na(outlier) | !outlier) %>%
    select(-row_id, -outlier, -type)
  
  #reverting to the original data frame
  data <- data_clean_final
  
  return(data)
}
  
  
#---------------------------------------------------------------------------------------------------
  
  