%Theo Vanderkooy
%Mr. Damian
%ICS 2OI
%2014-06-02
%Summative

/* In Progress/To Do:
 1) add sounds other than the music
 */

const settingsFile := 'Settings.txt'
const scoresFile := 'Highscores.dat'
type player :
    record
	lives : int
	score : int
	x : int
	y : int
	direction : int
    end record
type scoreType :
    record
	name : string (35)
	score : int
    end record
var highScores : array 1 .. 10 of scoreType
var settings :     %variable to hold the settings
    record
	p1col : int
	p2col : int
	speed : int
	lives : int
	music : boolean
    end record
proc saveHighscores  %procedure to save the highscores
    var file : int
    open : file, scoresFile, write %opens the file
    for count : 1 .. 10 %writes the scores to the file
	write : file, highScores (count)
    end for
    close : file %closes the file
end saveHighscores
proc readHighscores
    var file : int
    open : file, scoresFile, read %opens the file
    if file <= 0 then %if the file doesnt open
	for count : 1 .. 10 %sets all the high scores to be blank
	    highScores (count).name := "-----"
	    highScores (count).score := 0
	end for
    else %if the file does open
	for count : 1 .. 10
	    if eof (file) = true then %if it reaches the end of the file early
		for count2 : count .. 10 %the remainder of the highscores are set as blank
		    highScores (count2).name := "-----"
		    highScores (count2).score := 0
		end for
		exit
	    end if
	    read : file, highScores (count) %reads in a highscore
	end for
	close : file
    end if
end readHighscores
proc saveSettings         %procedure to save settings to a file
    var file : int
    open : file, settingsFile, put         %opens the file
    put : file, settings.p1col         %puts player 1's colour in the file
    put : file, settings.p2col         %puts player 2's colour in the file
    put : file, settings.speed         %puts the speed in the file
    put : file, settings.lives         %puts the starting lives in the file
    put : file, settings.music         %puts whether the music is on or off in the file
    close : file         %closes the file
end saveSettings
proc defaultSettings         %procedure to reset the settings to the defaults
    settings.p1col := 36         %sets player 1's colour to the default
    settings.p2col := 48         %sets player 2's colour to the default
    settings.speed := 2         %sets the speed to the default
    settings.lives := 5         %sets the number of lives to the default
    settings.music := true         %sets the music to on
    saveSettings         %saves the setting to the file
end defaultSettings
proc getSettings         %procedure to get the settings from the file
    var file : int
    open : file, settingsFile, get         %opens the file
    if file <= 0 then         %if the file doesn't open correctly then
	close : file         %the file is closed
	defaultSettings         %and settings are reset to the defaults
    else         %otherwise
	var input : array 1 .. 5 of string
	var success := true
	for settings : 1 .. 5         %gets 5 strings from the settings file
	    if eof (file) then         %if it hits eof first
		success := false         %remembers that it couldn't successfully get the settings
		exit         %and exits the for loop
	    else
		get : file, input (settings)         %if not eof then continues getting the settings
	    end if
	end for
	if success = true then         %if the settings were successfully retreived
	    loop
		if strintok (input (1)) = true and strint (input (1)) >= 32 and strint (input (1)) <= 55 then         %if the first string is a valid player colour
		    settings.p1col := strint (input (1))         %player 1's colour is saved as the first string
		else
		    defaultSettings         %otherwise settings are reset to defaults
		    exit
		end if
		if strintok (input (2)) = true and strint (input (2)) >= 32 and strint (input (2)) <= 55 then         %if the second string is a valid player colour
		    settings.p2col := strint (input (2))         %it is saved as player 2's colour
		else
		    defaultSettings         %otherwise settings are reset to defaults
		    exit
		end if
		if strintok (input (3)) = true and strint (input (3)) >= 1 and strint (input (3)) <= 3 then         %if the third string is a valid speed
		    settings.speed := strint (input (3))         %it is saved as the speed
		else
		    defaultSettings         %otherwise settings are reset to defaults
		    exit
		end if
		if strintok (input (4)) = true and strint (input (4)) >= 1 and strint (input (4)) <= 10 then         %if the 4th string is a valid life count
		    settings.lives := strint (input (4))         %it is saved as the starting lives count
		else
		    defaultSettings         %otherwise settings are reset to defaults
		    exit
		end if
		if input (5) = "true" then         %if the 5th string is 'true'
		    settings.music := true         %then the music setting is set to true
		elsif input (5) = "false" then         %if it is 'false'
		    settings.music := false         %then the music setting is set to false
		else
		    defaultSettings         %otherwise settings are reset to defaults
		end if
		exit
	    end loop
	else
	    defaultSettings         %if it fails settings are reset to defaults
	end if
    end if
end getSettings
%-------------
loop
    colour (black)
    colourback (white)
    var selection1 : int := 1         %keeps track of which menu item is currently selection1
    var input : string (1)
    setscreen ("nocursor,nobuttonbar")         %hides the cursor and the bar at the top of the screen
    loop
	var menuOptions : array 1 .. 6 of string := init ("   Play game    ", "  How to play   ", "    Settings    ", "  High scores   ", "    Credits     ", "      Quit      ")
	%declares the menu options
	cls
	locate (2, 35)
	put "GRIDLOCKED"             %puts the title at the top
	locate (18, 22)
	put "/\\ and \\/ arrow keys to navigate menu"             %outputs instructions for navigating the menu
	locate (19, 29)
	put "< arrow to go back/exit"
	locate (20, 32)
	put "> arrow to select"
	for count1 : 1 .. 6            %outputs the options menu
	    if count1 = selection1 then             %when putting the 'selection1' option it swaps the background and text colours
		colour (0)
		colourback (255)
	    else             %otherwise it uses normal colours
		colour (255)
		colourback (0)
	    end if
	    locate (3 + 2 * count1, 33)
	    put menuOptions (count1) ..         %puts the actual menu option
	    colourback (0)
	    colour (255)
	    if selection1 = count1 then         %puts an arrow next to the selection1 option
		put " > "
	    else
		put ""
	    end if
	end for
	Input.Flush
	getch (input)             %gets user input
	if ord (input) = 200 or input = 'w' then         %if they pressed the up arrow or 'w' it moves the selection 1 up
	    selection1 -= 1
	    if selection1 <= 0 then         %warps the selection from top to bottom if it would otherwise go above the top
		selection1 := 6
	    end if
	elsif ord (input) = 208 or input = 's' then         %if they press the down arrow or 's' it moves the selection 1 down
	    selection1 += 1
	    if selection1 >= 7 then         %wraps the selection back to the top if it would go below the bottom
		selection1 := 1
	    end if
	elsif ord (input) = 205 or input = 'd' or ord (input) = 10 or input = ' ' then         %if they press right arrow, 'd', enter or space it enters their selection
	    cls
	    exit
	elsif ord (input) = 203 or ord (input) = 27 or input = 'a' then         %if they press the left arrow, esc or 'a' it automatically selects 'quit'
	    cls
	    selection1 := 6
	    exit
	end if
    end loop
    case selection1 of
	    %---------------
	label 1 :         %if they select 'Play Game' the game runs
	    View.Set ("offscreenonly")
	    getSettings
	    if settings.music = true then
		Music.PlayFileLoop ("The Complex.mp3")         %plays background music from a file
	    end if
	    var board : array 0 .. 65, 0 .. 39 of boolean         %array to keep track of each square on the board
	    for count : 0 .. 65         %sets outside the bottom and top edges of the board to be true so that the players cannot leave the board
		board (count, 0) := true
		board (count, 39) := true
	    end for
	    for count : 1 .. 38         %sets outside the left and right edges of the board to true so the players cant leave the board
		board (0, count) := true
		board (65, count) := true
	    end for
	    colour (white)         %changes the text colour to white
	    colourback (black)         %changes the text background colour to black
	    var p1 : player
	    var p2 : player
	    p1.lives := settings.lives         %sets the players' lives to the starting number of lives
	    p2.lives := settings.lives
	    var totalTurns := 0
	    loop
		var gameEnd := 0         %variable to signal the end of a round/game (is reset to 0)
		drawfillbox (0, 0, maxx, maxy - 20, 9)         %colours the background light blue
		drawfillbox (0, maxy - 20, maxx, maxy, black)
		for boardX : 1 .. 64
		    for boardY : 1 .. 38         %makes a darker blue square for each square on the grid
			drawfillbox (10 * boardX - 9, 10 * boardY - 9, 10 * boardX - 1, 10 * boardY - 1, 1)
			board (boardX, boardY) := false         %sets the board squares to false so that the players can travel on them
		    end for
		end for
		board (5, 20) := true         %sets the starting position of each of the players to true
		board (60, 20) := true
		p1.x := 5         %sets the x and y coordinates and the direction of player 1
		p1.y := 20
		p1.direction := 2
		p2.x := 60         %sets the x and y coordinates and the direction of player 1
		p2.y := 20
		p2.direction := 4
		var chars : array char of boolean
		drawfillbox (10 * p1.x - 9, 10 * p1.y - 9, 10 * p1.x - 1, 10 * p1.y - 1, settings.p1col)         %draws the first square of each player
		drawfillbox (10 * p2.x - 9, 10 * p2.y - 9, 10 * p2.x - 1, 10 * p2.y - 1, settings.p2col)
		View.Update
		loop
		    locate (1, 1)
		    put "Player 1 lives: ", p1.lives : 2, repeat (" ", 43), "Player 2 lives: ", p2.lives : 2
		    totalTurns += 1 %keeps track of the number of turns in the game
		    Input.Flush          %clears keyboard buffer to ommit input lag
		    Input.KeyDown (chars)         %checks what keys are being pressed
		    if chars (chr (27)) then         %if Esc is pressed the game exits
			gameEnd := 2         %gameEnd is set to 2 to signal that the game has been exited
			exit
		    end if
		    if chars ('w') and (p1.direction = 4 or p1.direction = 2) then
			p1.direction := 1         %if 'w' is presses, player 1's direction is set to up as long as it doesnt cause the player to double back on their own trail
		    elsif chars ('d') and (p1.direction = 1 or p1.direction = 3) then
			p1.direction := 2         %if 'd' is presses, player 1's direction is set to right as long as it doesnt cause the player to double back on their own trail
		    elsif chars ('s') and (p1.direction = 4 or p1.direction = 2) then
			p1.direction := 3         %if 'd' is presses, player 1's direction is set to down as long as it doesnt cause the player to double back on their own trail
		    elsif chars ('a') and (p1.direction = 1 or p1.direction = 3) then
			p1.direction := 4         %if 'a' is presses, player 1's direction is set to left as long as it doesnt cause the player to double back on their own trail
		    end if
		    if chars (chr (200)) and (p2.direction = 4 or p2.direction = 2) then
			p2.direction := 1         %if up arrow is pressed, player 2's direction is set to up as long as it doesnt cause the player to double back on their own trail
		    elsif chars (chr (205)) and (p2.direction = 1 or p2.direction = 3) then
			p2.direction := 2         %if right arrow is pressed, player 2's direction is set to right as long as it doesnt cause the player to double back on their own trail
		    elsif chars (chr (208)) and (p2.direction = 4 or p2.direction = 2) then
			p2.direction := 3         %if down arrow is pressed, player 2's direction is set to down as long as it doesnt cause the player to double back on their own trail
		    elsif chars (chr (203)) and (p2.direction = 1 or p2.direction = 3) then
			p2.direction := 4         %if left arrow is pressed, player 2's direction is set to left as long as it doesnt cause the player to double back on their own trail
		    end if
		    case p1.direction of         %checks player 1's direction
			label 1 :         %if it is up
			    p1.y += 1         %moves player 1 up 1 space
			label 2 :         %if the direction is right
			    p1.x += 1         %moves the player 1 space in that direction
			label 3 :         %if it is down
			    p1.y -= 1         %moves the player 1 space in that direction
			label 4 :         %if it is left
			    p1.x -= 1         %moves the player 1 space in that direction
		    end case
		    case p2.direction of         %checks player 2's direction
			label 1 :         %if it is up
			    p2.y += 1         %moves the player 1 space in the direction
			label 2 :         %if it is right
			    p2.x += 1         %moves the player 1 space in the direction
			label 3 :         %if it is down
			    p2.y -= 1         %moves the player 1 space in the direction
			label 4 :         %if it is left
			    p2.x -= 1         %moves the player 1 space in the direction
		    end case
		    if (board (p1.x, p1.y) = true and board (p2.x, p2.y) = true) or (p1.x = p2.x and p1.y = p2.y) then         %if both players lose on the same turn
			gameEnd := 1         %gameEnd is set to 1 to signal a new round
		    elsif board (p1.x, p1.y) = true and board (p2.x, p2.y) = false then         %if player one loses and player two hasn't
			p1.lives -= 1
			gameEnd := 1         %gameEnd is set to 1 to signal a new round
		    elsif board (p1.x, p1.y) = false and board (p2.x, p2.y) = true then         %if player two loses and player one hasn't
			p2.lives -= 1
			gameEnd := 1         %gameEnd is set to 1 to signal a new round
		    else         %if neither player loses a life this turn
			board (p1.x, p1.y) := true         %sets the current positions of the players to false so they can't go through that space again
			board (p2.x, p2.y) := true
			case p1.direction of         %draws the next segment of player 1 based on its direction
			    label 1 :
				drawfillbox (10 * p1.x - 9, 10 * p1.y - 10, 10 * p1.x - 1, 10 * p1.y - 1, settings.p1col)
			    label 2 :
				drawfillbox (10 * p1.x - 10, 10 * p1.y - 9, 10 * p1.x - 1, 10 * p1.y - 1, settings.p1col)
			    label 3 :
				drawfillbox (10 * p1.x - 9, 10 * p1.y - 9, 10 * p1.x - 1, 10 * p1.y, settings.p1col)
			    label 4 :
				drawfillbox (10 * p1.x - 9, 10 * p1.y - 9, 10 * p1.x, 10 * p1.y - 1, settings.p1col)
			end case
			case p2.direction of         %draws the next segment of player 2 based on its direction
			    label 1 :
				drawfillbox (10 * p2.x - 9, 10 * p2.y - 10, 10 * p2.x - 1, 10 * p2.y - 1, settings.p2col)
			    label 2 :
				drawfillbox (10 * p2.x - 10, 10 * p2.y - 9, 10 * p2.x - 1, 10 * p2.y - 1, settings.p2col)
			    label 3 :
				drawfillbox (10 * p2.x - 9, 10 * p2.y - 9, 10 * p2.x - 1, 10 * p2.y, settings.p2col)
			    label 4 :
				drawfillbox (10 * p2.x - 9, 10 * p2.y - 9, 10 * p2.x, 10 * p2.y - 1, settings.p2col)
			end case
		    end if
		    exit when gameEnd not= 0         %stopts the game when there is a winner (or a tie, or esc is pressed)
		    View.Update
		    delay (15 * (settings.speed + 1))         %delay so that the players have time to react
		end loop
		View.Update
		exit when gameEnd = 2 or p1.lives = 0 or p2.lives = 0         %exits if the game was quit or if either player's lives hits 0
		delay (500)
	    end loop
	    Music.PlayFileStop         %stops the music
	    colour (black)
	    colourback (white)
	    View.Set ("nooffscreenonly")
	    cls
	    if p1.lives = 0 or p2.lives = 0 then
		totalTurns := totalTurns div settings.lives %divides the total turns by the number of lives at the start
		readHighscores %reads the highscores
		if p1.lives = 0 then %sets the winner's score by dividing 10 000 by the number of turns it took them to win
		    p2.score := 1000 div totalTurns
		    p1.score := 0
		elsif p2.lives = 0 then
		    p1.score := 1000 div totalTurns
		    p2.score := 0
		end if
		locate (7, 35)
		put "GAME OVER"
		locate (9, 22)
		if p2.lives = 0 then         %outputs which player won and their score
		    put "Player 1 wins with a score of: ", p1.score
		elsif p1.lives = 0 then
		    put "Player 2 wins with a score of: ", p2.score
		end if
		delay (800)
		locate (20, 27)
		Input.Flush
		put "Press any key to continue"
		getch (input)         %waits for user input before returning to the menu

		if (p2.lives > 0 and p2.score > highScores (10).score) or (p1.lives > 0 and p1.score > highScores (10).score) then
		    var gameScore : scoreType
		    cls
		    locate (7, 14)
		    if p1.score > p2.score then %outputs if either player got a new highscore
			put "Congratulations player 1, you got a new High Score!"
			gameScore.score := p1.score
		    elsif p2.score > p1.score then
			put "Congratulations player 2, you got a new High Score!"
			gameScore.score := p2.score
		    end if
		    locate (9, 16)
		    put "What is your name? " .. %asks them for their name
		    var highScoreName : string
		    get highScoreName : *
		    highScoreName += repeat (" ", 35)
		    gameScore.name := highScoreName (1 .. 35)
		    for decreasing count : 10 .. 1 %inserts the new highscore in the correct spot in the list
			if count = 1 then
			    highScores (count) := gameScore
			elsif gameScore.score <= highScores (count - 1).score then
			    highScores (count) := gameScore
			    exit
			else
			    highScores (count) := highScores (count - 1)
			end if
		    end for
		    saveHighscores %saves the highscores to the file
		end if
	    end if
	label 2 :         %If they select 'how to play' outputs the instructions of how to play the game
	    locate (2, 34)
	    put "HOW TO PLAY"
	    locate (5, 5)
	    put "Player 1 starts on the left of the screen, and uses W to move up, A to"
	    locate (6, 5)
	    put "move left, D to move right, and S to move down."
	    locate (8, 5)
	    put "Player 2 starts on the right of the screen, and uses the arrow keys to"
	    locate (9, 5)
	    put "to move in their respective directions."
	    locate (11, 5)
	    put "As the players move around they leave a trail behind them, crossing"
	    locate (12, 5)
	    put "these trails or leaving the screen will cause the player who did so to"
	    locate (13, 5)
	    put "lose a life. Each players' remaining lives is displayed at the top of"
	    locate (14, 5)
	    put "the screen. When a player loses all their lives then their opponent"
	    locate (15, 5)
	    put "wins the game."
	    locate (17, 5)
	    put "Score is based of how many turns it takes for the winner to win."
	    locate (20, 20)
	    put "Press any key to return to the main menu"
	    getch (input)         %waits for user input before returning to the menu
	label 3 :         %shows the settings menu
	    getSettings
	    locate (2, 36)
	    put "SETTINGS"
	    var settingsSelect : int := 1
	    var settingsMenu : array 1 .. 8 of string := init (" Player 1 colour  ", " Player 2 colour  ", " Speed            ", " Lives            ", " Music            ",
		" Save Settings    ",
		" Reset to default ", " Cancel/Back       ")
	    loop
		for settingsCount : 1 .. 5         %outputs the first 5 menu items
		    locate (2 * settingsCount + 3, 26)
		    put "< " ..         %puts a left arrow
		    if settingsCount = 1 then         %for the player colours
			colourback (settings.p1col)         %changes the background colour to that player's colour
			put "      " ..         %and puts spaces to show a sample of that colour
			colourback (0)         %resets the background colour to white
		    elsif settingsCount = 2 then
			colourback (settings.p2col)
			put "      " ..
			colourback (0)
		    elsif settingsCount = 3 then
			case settings.speed of         %outputs slow, medium or fast based on the speed setting
			    label 1 :
				put "Fast  " ..
			    label 2 :
				put "Medium" ..
			    label 3 :
				put "Slow  " ..
			end case
		    elsif settingsCount = 4 then
			put settings.lives : 2, "    " ..         %outputs the lives setting
		    elsif settingsCount = 5 then
			case settings.music of
			    label true :
				put "On    " ..         %outputs if the music setting is true or false
			    label false :
				put "Off   " ..
			end case
		    end if
		    put " > " ..         %outputs the right arrow
		    if settingsCount = settingsSelect then         %if the setting is selected swaps the background and text colours
			colour (0)
			colourback (255)
			put settingsMenu (settingsCount) ..         %and puts the menu item
			colour (255)         %and resets the colours back
			colourback (0)
			put ""
		    else
			put settingsMenu (settingsCount)         %otherwise puts the menu item normally
		    end if
		end for
		for settings2Count : 6 .. 8         %for the rest of the settings
		    locate (2 * settings2Count + 3, 37)
		    if settings2Count = settingsSelect then
			colour (0)
			colourback (255)         %changes the colours if it is selected
			put settingsMenu (settings2Count) ..         %and puts the option
			colour (255)         %and changes the colours back
			colourback (0)
			put " > "
		    else
			put settingsMenu (settings2Count)         %or just puts the option normally if not selected
		    end if
		end for
		getch (input)         %gets use input
		if ord (input) = 208 or input = 's' then         %if they press down arrow or 's' it moves the selection dowo
		    settingsSelect += 1
		    if settingsSelect > 8 then
			settingsSelect := 1         %and warps it back to the top if it goes past the bottom
		    end if
		elsif ord (input) = 200 or input = 'w' then         %if they press the up arrow or 'w'
		    settingsSelect -= 1         %moves the selection up by 1
		    if settingsSelect < 1 then         %and warps it back to the bottom if it goes past the top
			settingsSelect := 8
		    end if
		elsif ord (input) = 27 then         %if esc is press
		    exit         %exits back to the main menu
		elsif ord (input) = 205 or input = 'd' or input = ' ' or ord (input) = 10 then         %if right arrow, 'd', space or enter is pressed
		    case settingsSelect of
			label 1 :         %if player 1 colour is selected
			    settings.p1col += 1         %player 1's colour is increased by 1
			    if settings.p1col > 55 then         %if it goes past 55
				settings.p1col := 32         %it is set back to 32
			    end if
			label 2 :         %if player 2's colour is selected
			    settings.p2col += 1         %it is increased by 1
			    if settings.p2col > 55 then         %if it goes past 55
				settings.p2col := 32         %it is set back to 32
			    end if
			label 3 :         %if speed is selected
			    settings.speed -= 1         %it is increased by 1
			    if settings.speed < 1 then         %and set back to slow if it goes past fast
				settings.speed := 3
			    end if
			label 4 :         %if lives is selected
			    settings.lives += 1         %it is increased by 1
			    if settings.lives > 10 then         %if it exceeds 10
				settings.lives := 1         %it is set back to 1
			    end if
			label 5 :         %if music is selected
			    settings.music := not settings.music         %music is set to not music (on becomes off and vice versa)
			label 6 :         %if save is selected
			    locate (23, 25)
			    put "Saving settings, please wait..."
			    saveSettings         %it saves the settings
			    exit                             %and returns to the menu
			label 7 :         %if reset to default is selected
			    defaultSettings         %resets to default settings
			label 8 :         %if cancel is selected returns to main menu
			    exit
		    end case
		elsif ord (input) = 203 or input = 'a' then         %if left arrow or 'a' is pressed
		    case settingsSelect of
			label 1 :         %if player 1's colour is selected
			    settings.p1col -= 1         %it is lowered by 1
			    if settings.p1col < 32 then         %if it goes below 32 it is set back to 55
				settings.p1col := 55
			    end if
			label 2 :         %if player 2's colour is selected
			    settings.p2col -= 1         %it is lowered by 1
			    if settings.p2col < 32 then         %if it goes below 32 it is set back to 55
				settings.p2col := 55
			    end if
			label 3 :         %if the speed is selected
			    settings.speed += 1         %it is lowered by 1
			    if settings.speed > 3 then         %and set back to fast if it goes below slow
				settings.speed := 1
			    end if
			label 4 :         %if lives is selected
			    settings.lives -= 1         %it is lowered by 1
			    if settings.lives < 1 then         %and set back to 10 if it goes below 1
				settings.lives := 10
			    end if
			label 5 :         %if music is selected
			    settings.music := not settings.music         %music is set to not music (on becomes off and vice versa)
			label 8 :         %if cancel is selected
			    exit         %returns to main menu
			label :         %if anything else is selected it does nothing
		    end case
		end if
	    end loop
	label 4 :         % if they select High scores
	    readHighscores %reads the high scores from the file
	    locate (2, 34)
	    put "HIGH SCORES"
	    locate (5, 20)
	    put "Name                               Score"
	    for count : 1 .. 10 %outputs the highscores
		locate (count + 5, 20)
		put highScores (count).name : 35, highScores (count).score : 5
	    end for
	    locate (18, 20)
	    put "Press any key to return to the main menu"
	    getch (input)         %waits for user input to return to the menu
	label 5 :         %if they select credits outputs the credits
	    locate (2, 36)
	    put "CREDITS"
	    locate (5, 37)
	    put "Code:"
	    locate (6, 32)
	    put "Theo Vanderkooy"
	    locate (8, 37)
	    put "Music:"
	    locate (9, 17)
	    put "The Complex by Kevin MacLeod - incompetech.com"
	    locate (15, 20)
	    put "Press any key to return to the main menu"
	    getch (input)         %waits for user input to return to the menu
	label 6 :             %if they selected to quit, presents a menu asking them if they are sure
	    var selection2 : int := 1
	    var quitMenu : array 1 .. 2 of string := init ("     Yes, quit      ", " No, return to menu ")             %declares the options in the menu
	    cls
	    locate (2, 25)
	    put "Are you sure you want to quit?"             %asks if they are sure they want to quit
	    loop
		for count2 : 1 .. 2             %outputs the options in the menu
		    if count2 = selection2 then             %if the options is currently selected it reverses the colour/background colour
			colour (0)
			colourback (255)
		    else
			colour (255)
			colourback (0)
		    end if
		    locate (3 + 2 * count2, 30)
		    put quitMenu (count2) ..             %puts the option
		    colour (255)
		    colourback (0)
		    if count2 = selection2 then             %puts an arrow after the currently selected option
			put " > "
		    else
			put ""
		    end if
		end for
		getch (input)             %gets user input
		if ord (input) = 200 or ord (input) = 208 or input = 'w' or input = 's' then         %if the up or down arrow keys or 's' or 'w' are pressed it selects the other of the two options
		    if selection2 = 1 then
			selection2 := 2
		    else
			selection2 := 1
		    end if
		elsif ord (input) = 203 or input = 'a' then             %if the left arrow key is pressed or 'a' is pressed it sets their selection to return to the main menu and exits this menu
		    selection2 := 2
		    exit
		elsif ord (input) = 205 or input = 'd' or input = ' ' or ord (input) = 10 then         %if right arrow key or 'd' or space or enter is pressed it exits this menu
		    exit
		elsif ord (input) = 27 then         %if esc is pressed it exits the game
		    selection2 := 1
		    exit
		end if
	    end loop
	    exit when selection2 = 1             %after exiting the menu it exits the entire program if the user chose to
    end case
end loop
cls
locate (12, 30)
put "Thanks for Playing!"
