% Hexagon

var playerPos : real
var blocks : array 1 .. 5, 1 .. 6 of boolean
var blocksPos : array 1 .. 5 of int
var timer : real
var input : string (1)
var chars : array char of boolean
var speed : real := 0.18
View.Set ("offscreenonly,nocursor")
var prevBlock : int
var angle : real
var ran : int
var anglechange : real
var gameOver : boolean
fcn yCoord (b, r, t : real) : int %y coordinate finder
    result round (b + r * sind (t))
end yCoord
fcn xCoord (a, r, t : real) : int %x coordingat finder
    result round (a + r * cosd (t))
end xCoord
proc DrawScreen %draws the screen
    cls
    put "Time: ", timer
    var x : array 1 .. 6 of int
    var y : array 1 .. 6 of int
    angle += anglechange %changes the angles
    if angle > 360 then
	angle -= 360
    elsif angle < 0 then
	angle += 360
    end if
    for count1 : 1 .. 6
	x (count1) := xCoord (320, 50, angle + (count1 - 1) * 60)
	y (count1) := yCoord (200, 50, angle + (count1 - 1) * 60)
    end for
    drawpolygon (x, y, 6, black) %draws middle hexagon
    var xPlayer, yPlayer : int
    xPlayer := xCoord (320, 60, angle + playerPos * 60)
    yPlayer := yCoord (200, 60, angle + playerPos * 60)
    drawoval (xPlayer, yPlayer, 2, 2, black) %draws player
    for count1 : 1 .. upper (blocksPos)
	for count2 : 1 .. 6
	    if blocks (count1, count2) = true then %draws the lines
		drawline (xCoord (320, 50 + (blocksPos (count1) / 2), angle + 60 * (count2 - 1)), yCoord (200, 50 + (blocksPos (count1) / 2), angle + 60 * (count2 - 1)), xCoord (320, 50
		    + (blocksPos (count1) / 2), angle + 60 * (count2)), yCoord (200, 50 + (blocksPos (count1) / 2), angle + 60 * (count2)), black)
	    end if
	end for
    end for
    View.Update
end DrawScreen

locate (5, 36)
put "HEXAGON"
locate (11, 10)
put "Use left/right arrow or a/d keys to move around the hexagon"
locate (12, 16)
put "Avoid the falling blocks for as long as possible"
View.Update
delay (500)
locate (18, 27)
put "Press any key to continue"
View.Update
Input.Flush
var x : string (1)
getch (x)
var c1, c2 : int
loop
    gameOver := false %resets a bunch of stuff
    prevBlock := 0
    playerPos := 1
    for count1 : 1 .. upper (blocksPos)
	blocksPos (count1) := 0
    end for
    for count1 : 1 .. 5
	for count2 : 1 .. 6
	    blocks (count1, count2) := false
	end for
    end for
    timer := 0
    angle := 0
    anglechange := 5
    loop
	clock (c1)
	var randno : int
	randint (randno, 1, 100)
	if randno = 1 then %randomly changes the direction/speed of rotation
	    anglechange := -anglechange
	    randint (randno, 6, 12)
	    if anglechange > 0 then
		anglechange := randno / 3
	    else
		anglechange := -randno / 3
	    end if
	end if
	Input.Flush
	Input.KeyDown (chars) %gets user input and does stuff
	if chars ('a') = true or chars (chr (203)) = true then
	    playerPos += speed
	elsif chars ('d') = true or chars (chr (205)) = true then
	    playerPos -= speed
	elsif chars (chr (27)) then
	    exit
	end if
	if playerPos < 0 then
	    playerPos += 6
	elsif playerPos >= 6 then
	    playerPos -= 6
	end if
	if round (timer * 100) rem 40 = 0 then
	    if prevBlock = 5 then %moves old blocks to top
		prevBlock := 0
	    end if
	    prevBlock += 1
	    var openSpace : int
	    randint (openSpace, 1, 6) %sets the open spot
	    for count : 1 .. 6 %randomly sets the others to not be open
		if count not= openSpace then
		    randint (randno, 1, 5)
		    if randno <= 4 then
			blocks (prevBlock, count) := true
		    else
			blocks (prevBlock, count) := false
		    end if
		else
		    blocks (prevBlock, count) := false
		end if
		blocksPos (prevBlock) := 1000
	    end for
	end if
	for count : 1 .. upper (blocksPos)
	    blocksPos (count) -= 10 %moves the blocks in
	end for
	for count : 1 .. 5
	    if blocksPos (count) = 20 and blocks (count, ceil (playerPos)) = true then
		gameOver := true %if player hits a block they die
		exit
	    end if
	end for
	exit when gameOver = true
	DrawScreen                 %updates screen
	timer += 0.02
	clock (c2)
	delay (20 - (c1 - c2)) %increases the timer/waits
    end loop
    colour (white)
    colourback (black)
    locate (2, 26)
    put " You survived ", timer-.02, " seconds " ..
    colour (black)
    colourback (white)
    put ""
    View.Update
    delay (500)
    locate (24, 7)
    colour (white)
    colourback (black)
    put " Press 'w' or up arrow to replay, 's', down arrow or ESC to quit " ..
    colour (black)
    colourback (white)
    put ""
    View.Update
    loop
	Input.Flush
	getch (input) %repeats if they want
	exit when input = chr (200) or input = 'w'
	if ord (input) = 208 or input = 's' or ord (input) = 27 then
	    return
	end if
    end loop
end loop
