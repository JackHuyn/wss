func knight_movment(attack_board_dict):
	var possible_moves_list = []
	var curr = ab_to_coord(attack_board_dict)
	var x = curr[0]
	var y = curr[1]
	var entry_left
	var entry_right
	
	#up
	for i in range(1,3,1):
		var entry = coord_to_ab([x,y+i], attack_board_dict['corner_square']['column'])
		if(!entry.size() == 0):
			#check left right 2
			entry_left = coord_to_ab([x - (3 - i),y+i], attack_board_dict['corner_square']['column'])
			entry_right = coord_to_ab([x + (3 - i),y+i], attack_board_dict['corner_square']['column'])
			check_and_append_entry(entry_left, possible_moves_list)
			check_and_append_entry(entry_right, possible_moves_list)
	
	#down
	for i in range(1,3,1):
		var entry = coord_to_ab([x,y-i], attack_board_dict['corner_square']['column'])
		if(!entry.size() == 0):
			#check left right 2
			entry_left = coord_to_ab([x - (3 - i),y-i], attack_board_dict['corner_square']['column'])
			entry_right = coord_to_ab([x + (3 - i),y-i], attack_board_dict['corner_square']['column'])
			check_and_append_entry(entry_left, possible_moves_list)
			check_and_append_entry(entry_right, possible_moves_list)
	
	#right
	for i in range(1,3,1):
		var entry = coord_to_ab([x+i,y], attack_board_dict['corner_square']['column'])
		if(!entry.size() == 0):
			#check left right 2
			entry_left = coord_to_ab([x+i,y+(3-i)], attack_board_dict['corner_square']['column'])
			entry_right = coord_to_ab([x+i,y-(3-i)], attack_board_dict['corner_square']['column'])
			check_and_append_entry(entry_left, possible_moves_list)
			check_and_append_entry(entry_right, possible_moves_list)
	
	#left
	for i in range(1,3,1):
		
		var entry = coord_to_ab([x-i,y], attack_board_dict['corner_square']['column'])
		
		if(!entry.size() == 0):
			#check left right 2
			entry_left = coord_to_ab([x-i,y+(3-i)], attack_board_dict['corner_square']['column'])
			entry_right = coord_to_ab([x-i,y-(3-i)], attack_board_dict['corner_square']['column'])
			check_and_append_entry(entry_left, possible_moves_list)
			check_and_append_entry(entry_right, possible_moves_list)
	
	return possible_moves_list

func bishop_movment(attack_board_dict):
	var possible_moves_list = []
	var curr = ab_to_coord(attack_board_dict)
	var x = curr[0]
	var y = curr[1]
	
	#diag up L->R
	for i in range(0,4,1):
		var entry = coord_to_ab([x+1,y+1], attack_board_dict['corner_square']['column'])
		if (entry.size() != 0 and Global3D.is_corner_occupied(entry)) or entry.is_empty():
			break
		check_and_append_entry(entry, possible_moves_list)
		x += 1
		y += 1
	x = curr[0]
	y = curr[1]
	
	#diag down L->R
	for i in range(0,4,1):
		var entry = coord_to_ab([x+1,y-1], attack_board_dict['corner_square']['column'])
		if (entry.size() != 0 and Global3D.is_corner_occupied(entry)) or entry.is_empty():
			break
		check_and_append_entry(entry, possible_moves_list)
		x += 1
		y -= 1
	x = curr[0]
	y = curr[1]
	
	#diag up R->L
	for i in range(0,4,1):
		var entry = coord_to_ab([x-1,y+1], attack_board_dict['corner_square']['column'])
		if (entry.size() != 0 and Global3D.is_corner_occupied(entry)) or entry.is_empty():
			break
		check_and_append_entry(entry, possible_moves_list)
		x -= 1
		y += 1
	x = curr[0]
	y = curr[1]
	
	#diag down R->L
	for i in range(0,4,1):
		var entry = coord_to_ab([x-1,y-1], attack_board_dict['corner_square']['column'])
		if (entry.size() != 0 and Global3D.is_corner_occupied(entry)) or entry.is_empty():
			break
		check_and_append_entry(entry, possible_moves_list)
		x -= 1
		y -= 1
	x = curr[0]
	y = curr[1]
	
	return possible_moves_list

func rook_movment(attack_board_dict):
	var possible_moves_list = []
	var curr = ab_to_coord(attack_board_dict)
	var x = curr[0]
	var y = curr[1]
	
	#up
	for i in range(0,4,1):
		var entry = coord_to_ab([x,y+1], attack_board_dict['corner_square']['column'])
		if (entry.size() != 0 and Global3D.is_corner_occupied(entry)) or entry.is_empty():
			break
		check_and_append_entry(entry, possible_moves_list)
		y += 1
	x = curr[0]
	y = curr[1]
	
	#down
	for i in range(0,4,1):
		var entry = coord_to_ab([x,y-1], attack_board_dict['corner_square']['column'])
		if (entry.size() != 0 and Global3D.is_corner_occupied(entry)) or entry.is_empty():
			break
		check_and_append_entry(entry, possible_moves_list)
		y -= 1
	x = curr[0]
	y = curr[1]
	
	#right
	for i in range(0,4,1):
		var entry = coord_to_ab([x+1,y], attack_board_dict['corner_square']['column'])
		if (entry.size() != 0 and Global3D.is_corner_occupied(entry)) or entry.is_empty():
			break
		check_and_append_entry(entry, possible_moves_list)
		x += 1
	x = curr[0]
	y = curr[1]
	
	#left
	for i in range(0,4,1):
		var entry = coord_to_ab([x-1,y], attack_board_dict['corner_square']['column'])
		if (entry.size() != 0 and Global3D.is_corner_occupied(entry)) or entry.is_empty():
			break
		check_and_append_entry(entry, possible_moves_list)
		x -= 1
	x = curr[0]
	y = curr[1]
	
	return  possible_moves_list

func queen_movment(attack_board_dict):
	var possible_moves_list = []
	
	possible_moves_list += rook_movment(attack_board_dict)
	possible_moves_list += bishop_movment(attack_board_dict)
	
	return  possible_moves_list

func king_movment(attack_board_dict):
	var possible_moves_list = []
	var curr = ab_to_coord(attack_board_dict)
	var x = curr[0]
	var y = curr[1]
	
	#up
	for i in range(0,1,1):
		var entry = coord_to_ab([x,y+1], attack_board_dict['corner_square']['column'])
		check_and_append_entry(entry, possible_moves_list)
		y += 1
	x = curr[0]
	y = curr[1]
	
	#down
	for i in range(0,1,1):
		var entry = coord_to_ab([x,y-1], attack_board_dict['corner_square']['column'])
		check_and_append_entry(entry, possible_moves_list)
		y -= 1
	x = curr[0]
	y = curr[1]
	
	#right
	for i in range(0,1,1):
		var entry = coord_to_ab([x+1,y], attack_board_dict['corner_square']['column'])
		check_and_append_entry(entry, possible_moves_list)
		x += 1
	x = curr[0]
	y = curr[1]
	
	#left
	for i in range(0,1,1):
		var entry = coord_to_ab([x-1,y], attack_board_dict['corner_square']['column'])
		check_and_append_entry(entry, possible_moves_list)
		x -= 1
	x = curr[0]
	y = curr[1]
	
	return  possible_moves_list

# ------------------------------ Helper Functions ------------------------------

# Helper function to check and append valid entries
func check_and_append_entry(entry, possible_moves_list):
	if entry.size() != 0 and !Global3D.is_corner_occupied(entry) and entry not in possible_moves_list:
		possible_moves_list.append(entry)

# Note: these next fucntions assume virtual 2D coordinants for attack boards
# where (x=0, y=0) would be the initial possition for whites attackboard for either side

# translates iteration coords into attackboard dictionary
func coord_to_ab(coords, col):
	
	var void_spacees = [[0, 2], [0, 3], [1, 3], [1, 0], [3, 0], [3, 3], [4, 0], [4, 1]]
	
	var board
	var row 
	var is_up
	
	# check out of bounds
	if (coords[0] > 4 or coords[0] < 0):
		return{}
	
	if (coords[1] > 3 or coords[1] < 0):
		return{}
	
	# Check if the given coordinate exists in the void_spacees list
	for void_space in void_spacees:
		if void_space == coords:
			return {}
	
	#coords[0] -> x
	if (coords[0] == 1 ):
		board = Global3D.BOARD_TYPE.NEUTRAL
		row = 1
		
	elif (coords[0] == 3):
		board = Global3D.BOARD_TYPE.NEUTRAL
		row = 4
		
	elif (coords[0] == 0):
		board = Global3D.BOARD_TYPE.WHITE
		row = 1
		
	elif (coords[0] == 4):
		board = Global3D.BOARD_TYPE.BLACK
		row = 4
		
	elif (coords[0] == 2):
		if (coords[1] <= 1):
			board = Global3D.BOARD_TYPE.WHITE
			row = 4
		elif (coords[1] >= 2):
			board = Global3D.BOARD_TYPE.BLACK
			row = 1
	
	# determin is_up
	if (board == Global3D.BOARD_TYPE.WHITE):
		if(coords[1] == 0):
			is_up = false
		elif (coords[1] == 1):
			is_up = true
	
	if (board == Global3D.BOARD_TYPE.NEUTRAL):
		if(coords[1] == 1):
			is_up = false
		elif (coords[1] == 2):
			is_up = true
	
	if (board == Global3D.BOARD_TYPE.BLACK):
		if(coords[1] == 2):
			is_up = false
		elif (coords[1] == 3):
			is_up = true
	
	# construct return dictionary
	var entery = {}
	entery = {
		'column': col,
		'row': row,
		'board': board,
		'is_up': is_up
	}
	
	return entery

# get the coord of an ab
func ab_to_coord(ab):
	var x
	var y
	
	if(ab["corner_square"]["board"] == Global3D.BOARD_TYPE.WHITE):
		if (ab["corner_square"]["row"] == 1):
			x = 0
		elif (ab["corner_square"]["row"] == 4):
			x = 2
			
		if (ab["is_up"] == false):
			y = 0
		elif (ab["is_up"] == true):
			y = 1
	
	if(ab["corner_square"]["board"] == Global3D.BOARD_TYPE.NEUTRAL):
		if (ab["corner_square"]["row"] == 1):
			x = 1
		elif (ab["corner_square"]["row"] == 4):
			x = 3
			
		if (ab["is_up"] == false):
			y = 1
		elif (ab["is_up"] == true):
			y = 2
	
	if(ab["corner_square"]["board"] == Global3D.BOARD_TYPE.BLACK):
		if (ab["corner_square"]["row"] == 1):
			x = 2
		elif (ab["corner_square"]["row"] == 4):
			x = 4
			
		if (ab["is_up"] == false):
			y = 2
		elif (ab["is_up"] == true):
			y = 3
	
	return [x,y]
