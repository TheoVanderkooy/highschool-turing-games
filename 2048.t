%2048


View.Set ("offscreenonly,nocursor")
var board : array 0 .. 5, 0 .. 5 of int
var canMove : boolean
var score : int
proc refresh
    cls
    locate (3, floor (40 - (length ("score: " + intstr (score)) / 2)))
    put "Score: ", score
    for count1 : 1 .. 4
	for count2 : 1 .. 4
	    if board (count1, count2) > 0 then
		locate (4 + 3 * count2, 23 + 6 * count1)
		if board (count1, count2) = 2 then
		elsif board (count1, count2) = 4096 then
		    colourback (32)
		    colour (white)
		elsif board (count1, count2) >= 8192 then
		    colourback (black)
		    colour (white)
		elsif board (count1, count2) = 2048 then
		    colourback (55)
		elsif board (count1, count2) = 1024 then
		    colourback (54)
		else
		    case board (count1, count2) of
			label 4 :
			    colourback (44)
			label 8 :
			    colourback (45)
			label 16 :
			    colourback (46)
			label 32 :
			    colourback (47)
			label 64 :
			    colourback (48)
			label 128 :
			    colourback (49)
			label 256 :
			    colourback (50)
			label 512 :
			    colourback (53)
		    end case
		end if
		put board (count1, count2) : 3, " " ..
		colour (black)
		colourback (white)
		put ""
	    end if
	end for
    end for
    View.Update
end refresh
proc gameMove (var canMove : boolean)
    canMove := false
    for x : 1 .. 4
	for y : 1 .. 4
	    if (board (x, y) = 0) or (board (x, y) = board (x + 1, y)) or (board (x, y) = board (x - 1, y)) or (board (x, y) = board (x, y + 1)) or (board (x, y) = board (x, y - 1)) then
		canMove := true
		exit
	    end if
	end for
	exit when canMove = true
    end for
end gameMove
proc newBlock
    var emptyBlocks := 0
    for x : 1 .. 4
	for y : 1 .. 4
	    if board (x, y) = 0 then
		emptyBlocks += 1
	    end if
	end for
    end for
    randint (emptyBlocks, 1, emptyBlocks)
    for x : 1 .. 4
	for y : 1 .. 4
	    if board (x, y) = 0 then
		emptyBlocks -= 1
		if emptyBlocks = 0 then
		    board (x, y) := 2
		    exit
		end if
	    end if
	end for
	exit when emptyBlocks = 0
    end for
end newBlock
loop
    score := 0
    canMove := true
    for count1 : 0 .. 5
	for count2 : 0 .. 5
	    if count1 = 0 or count1 = 5 or count2 = 0 or count2 = 5 then
		board (count1, count2) := -1
	    else
		board (count1, count2) := 0
	    end if
	end for
    end for
    var r1, r2 : int
    for count : 1 .. 2
	loop
	    randint (r1, 1, 4)
	    randint (r2, 1, 4)
	    if board (r1, r2) = 0 then
		board (r1, r2) := 2
		exit
	    end if
	end loop
    end for
    refresh
    var input : string (1)
    loop
	loop
	    var success := false
	    gameMove (canMove)
	    if canMove = true then
		getch (input)
	    end if
	    case input of
		label chr (27) :
		    canMove := false
		    exit
		label 'a', chr (203) :
		    if canMove = true then
			for y : 1 .. 4
			    for x1 : 1 .. 3
				for x2 : x1 + 1 .. 4
				    if board (x1, y) = 0 then
					if board (x2, y) > 0 then
					    success := true
					end if
					board (x1, y) := board (x2, y)
					board (x2, y) := 0
				    elsif board (x1, y) = board (x2, y) then
					board (x1, y) *= 2
					board (x2, y) := 0
					success := true
					score += board (x1, y)
					exit
				    elsif board (x1, y) not= 0 and board (x2, y) not= 0 and board (x1, y) not= board (x2, y) then
					exit
				    elsif (board (x1, y) and board (x2, y)) = 0 then
				    end if
				end for
			    end for
			end for
		    else
			exit
		    end if
		label 's', chr (208) :
		    if canMove = true then
			for x : 1 .. 4
			    for decreasing y1 : 4 .. 2
				for decreasing y2 : y1 - 1 .. 1
				    if board (x, y1) = 0 then
					if board (x, y2) > 0 then
					    success := true
					end if
					board (x, y1) := board (x, y2)
					board (x, y2) := 0
				    elsif board (x, y1) = board (x, y2) then
					board (x, y1) *= 2
					board (x, y2) := 0
					success := true
					score += board (x, y1)
					exit
				    elsif board (x, y1) not= 0 and board (x, y2) not= 0 and board (x, y1) not= board (x, y2) then
					exit
				    elsif (board (x, y1) and board (x, y2)) = 0 then
				    end if
				end for
			    end for
			end for
		    else
			exit
		    end if
		label 'w', chr (200) :
		    if canMove = true then
			for x : 1 .. 4
			    for y1 : 1 .. 3
				for y2 : y1 + 1 .. 4
				    if board (x, y1) = 0 then
					if board (x, y2) > 0 then
					    success := true
					end if
					board (x, y1) := board (x, y2)
					board (x, y2) := 0
				    elsif board (x, y1) = board (x, y2) then
					board (x, y1) *= 2
					board (x, y2) := 0
					success := true
					score += board (x, y1)
					exit
				    elsif board (x, y1) not= 0 and board (x, y2) not= 0 and board (x, y1) not= board (x, y2) then
					exit
				    elsif (board (x, y1) and board (x, y2)) = 0 then
				    end if
				end for
			    end for
			end for
		    else
			exit
		    end if
		label 'd', chr (205) :
		    if canMove = true then
			for y : 1 .. 4
			    for decreasing x1 : 4 .. 2
				for decreasing x2 : x1 - 1 .. 1
				    if board (x1, y) = 0 then
					if board (x2, y) > 0 then
					    success := true
					end if
					board (x1, y) := board (x2, y)
					board (x2, y) := 0
				    elsif board (x1, y) = board (x2, y) then
					board (x1, y) *= 2
					board (x2, y) := 0
					success := true
					score += board (x1, y)
					exit
				    elsif board (x1, y) not= 0 and board (x2, y) not= 0 and board (x1, y) not= board (x2, y) then
					exit
				    elsif (board (x1, y) and board (x2, y)) = 0 then
				    end if
				end for
			    end for
			end for
		    else
			exit
		    end if
		label :
	    end case
	    exit when canMove = false
	    if success = true then
		newBlock
		refresh
	    end if
	end loop
	exit when canMove = false
    end loop
    refresh
    locate (20, 35)
    put "Game Over"
    View.Update
    delay (500)
    locate (21, 21)
    put "Press enter to restart or ESC to quit."
    View.Update
    loop
	Input.Flush
	getch (input)
	exit when input = chr (27) or input = chr (10)
    end loop
    exit when input = chr (27)
end loop
