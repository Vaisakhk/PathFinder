# Nueroglee App

### Architecture
     - VIPER

### Requirements
     - iOS 13.0 and above
     - Xcode Version 12.2
     - Only support iPad and iPhone Portrait mode 
     
### Assemptions
     - Assuming application only support Portrait mode
     - Assuming each Boxes on the screen represent users and all the covid connections will be represented by lines
     - Assuming all the numbers on the box indicates the order of contact tracing
     - Assuming upto 5 seconds after game start user can't do anything
     - Assuming after 5 seconds Numbers will be disappeared from the Box, and numbers will be displayed on bottom of the screen
     - Assuming Users need to place(drag and drop) each number correctly in the box.
     - Assuming user can play N number of times
     - Assuming each success move has +1 and each failure move have -1 points
     - Game follows level concept once user complete first level then moves to next level. If the user clicks back button or close the app current lavel(last uncomplete level) will restart
     
### Approach
     - Used Touch deletages to drag and drop the views
     - Using Core Data for the local storage
     - Created 2 entities one for Levels and one for Saving Score on each user move.
     - Created One to Many relationship from "Level" to "Scores".
     - Created One to One relationship "Scores" to "Level".
     
### Features
    - Landing screen
       - Showing Total Score achived for all the levels
       - Showing current Level(Last level which is incomplete)
       - Given start button to start the game, on clicking start button navigate to game controller
       - Given History button, on clicking it navigate to History.
       - Given an option to read all the game rules.
    - Game Screen
       - Once open the game view timer will start running
       - On Screen only current level score is displaying
       - Upto 5 seconds number will display in UI, User need to wait until 5 seconds
       - After 5 seconds numbers will be disappeared from the Box, and numbers will be displayed on bottom of the screen
       - User need to drag and drop th numbers based on there memory
       - Once User places all the numbers correctly an analytics page will display. Which will show all the user moves, time taken, score obtaind etc.
       - Reset option provided to reset current level.
    - History screen
       - All the levels which user played will show in history
       - Total score obtained, time taken, completed status will display in table view.
       - On clicking each item in table view an analytics page will display. Which will show all the user moves, time taken, score obtaind etc.
       
### Depedency
    - No dependancy on external libraries

### Unit Testing
    - Created Unit test for bussiness logic (Landing, Home, History andHistory Detail interactor)
