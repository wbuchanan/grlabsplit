cscript "Unit tests for grlabsplit" adofile grlabsplit.ado

// Create a test data set with 10 observations
clear
set obs 10
g x = rnormal(0, 1)
g y = runiform()
la var x "This label is too short to be split"
la var y "This label, however, is longer than the default to be split into two pieces"

preserve

	grlabsplit x y
	assert `"`: char x[ti_chunk_1]'"' == "This label is too short to be split"
	assert `"`: char y[ti_chunk_1]'"' == "This label, however, is longer than the default to"
	assert `"`: char y[ti_chunk_2]'"' == "be split into two pieces"
	assert `"`: char x[title]'"' == `""This label is too short to be split""'
	assert `"`: char y[title]'"' == `""This label, however, is longer than the default to" "be split into two pieces""'

restore, preserve
	
	grlabsplit x y, grlablength(30)
	assert `"`: char x[ti_chunk_1]'"' == "This label is too short to be"
	assert `"`: char x[ti_chunk_2]'"' == "split"
	assert `"`: char y[ti_chunk_1]'"' == "This label, however, is longer"
	assert `"`: char y[ti_chunk_2]'"' == "than the default to be split" 
	assert `"`: char y[ti_chunk_3]'"' == "into two pieces" 
	assert `"`: char x[title]'"' == `""This label is too short to be" "split""'
	assert `"`: char y[title]'"' == ///   
	`""This label, however, is longer" "than the default to be split" "into two pieces""'

restore, preserve
	
	grlabsplit x y, grlablength(20)
	assert `"`: char x[ti_chunk_1]'"' == "This label is too"
	assert `"`: char x[ti_chunk_2]'"' == "short to be split"
	assert `"`: char x[title]'"' == `""This label is too" "short to be split""'
	assert `"`: char y[ti_chunk_1]'"' == "This label, however,"
	assert `"`: char y[ti_chunk_2]'"' == "is longer than the"
	assert `"`: char y[ti_chunk_3]'"' == "default to be split"
	assert `"`: char y[ti_chunk_4]'"' == "into two pieces"
	assert `"`: char y[title]'"' ==												 ///
	`""This label, however," "is longer than the" "default to be split" "into two pieces""'

restore

	
