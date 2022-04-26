//MADE BY MAX WEINREB
program printcase
    version 17.0

	syntax anything(everything id = "if id_variable == id_val"), [pdf font(string) noempty ignore(string asis) replace addnotes width(string) LONGitudinal unit(string) landscape]
	tokenize `anything', parse("==")
	local fileName = ""
	local varName = ""
	local varNum = ""
	
	//Checking for correct syntax and assigning macros
	if("`2'" != "=="){
		display "Must have '==' expression"
		error 198
	}
	
	if("`3'" == ""){
		display "Cannot have empty id_val"
		error 198
	}
	local varNum = "`3'"

	tokenize `1'
	
	if("`1'" != "using" & "`1'" != "if"){
		display "Must follow printcase syntax"
		error 198
	} 
	else if("`1'" == "if"){
		local varName `2'
	} 
	else {
		local fileName = "`2'"
		if("`3'" != "if"){
			display "Must have if expression"
			error 198 
		}
		local varName `4'
	}
	//checking for extra unnecessary arguments
	if("`fileName'" != ""){
		if("`5'" != ""){
			display "Too many arguments passed"
			error 198
		} 
	}
	else{
		if("`3'" != ""){
			display "Too many arguments passed"
			error 198
		}
	}
	
	
    //Setting up documents, either pdf or word
	display "ID Variable: `varName'"
	display "ID Value: `varNum'"
	
	if("`font'" == "") {
		local docFont = "Arial"
	}
	else {
		local docFont = "`font'"
	}
	local doccmd putdocx
	if "`pdf'" != ""{
		local doccmd putpdf
	}
	local indexSlash = strrpos("`c(filename)'", "\") 
	local myFile = substr("`c(filename)'", `indexSlash'+1, strlen("`c(filename)'")-`indexSlash')
	`doccmd' clear
	
	local landsc = ""
	if("`landscape'" != ""){
		local landsc = "landscape"
	}
	//Title and setting up document
	if("`pdf'"!=""){
		putpdf begin, font("`docFont'") `landsc'
		//Title
		putpdf paragraph
		putpdf text (`"`varName' `varNum'"'), font("`docFont'",30) bold
		
		//Headers
		putpdf paragraph
		putpdf text ("User: `c(username)'"), font("`docFont'",20)
		putpdf paragraph
		putpdf text (`"`myFile'"'), font("`docFont'",20)
		putpdf paragraph
		putpdf text ("Date Printed: `c(current_date)'"), font("`docFont'",20)
	}
	else{
		putdocx begin, pagenum(decimal) footer(footer1) font("`docFont'") `landsc'
		//Title
		putdocx paragraph, style(Title) 
		putdocx text (`"`varName' `varNum'"'), font("`docFont'")

		
		//Headers
		putdocx paragraph, style(Heading1) 
		putdocx text ("User: `c(username)'"), font("`docFont'")
		putdocx paragraph, style(Heading1)
		putdocx text (`"`myFile'"'), font("`docFont'")
		putdocx paragraph, style(Heading1)
		putdocx text ("Date Printed: `c(current_date)'"), font("`docFont'")

		//Pagenumbers + footer1
		putdocx paragraph, tofooter(footer1)
		putdocx pagenumber
		putdocx text ("		printcase_`varNum'_`myFile'")
	}
	`doccmd' paragraph

    //Retreiving list of variables
    quietly describe, varlist
	local dataVars  `r(varlist)'
    local rowNum = `r(k)'
    local ++rowNum
	
	//if longitudinal find # columns, initiliaze longitudinal variable list
	local colNum = 3
	local numWaves = 1
	tempvar id_wave
	if("`longitudinal'" != ""){
		preserve
		//find # waves
		quietly count if `varName' == `varNum'
		local numWaves = `r(N)'
		sort `varName'
		quietly by `varName': generate `id_wave' = _n if `varName' == `varNum'
		local colNum = 2+`numWaves'
	}

    //Initializing table
	if("`width'" != ""){
		`doccmd' table tbl = (`rowNum', `colNum'), width(`width')
	}
	else {
		`doccmd' table tbl = (`rowNum', `colNum')
	}
	
	
	`doccmd' table tbl(1,1) = ("Variable Name")
	`doccmd' table tbl(1,2) = ("Variable Label")
	local colTitle = "Response"
	if("`unit'" != ""){
		local colTitle = "`unit'"
	}
	forvalues w = 1/`numWaves'{
		local col = 2+`w'
		`doccmd' table tbl(1,`col') = ("`colTitle' "+"`w'")
	}
	
    local i = 2

    foreach var in `dataVars' {
		//Prevent rows from overflowing to next page
		`doccmd' table tbl(`i', .), nosplit

	   //Response for case
	   local skipRow = 0
	   local varlabel : value label `var'
	   
	   //used to keep track of skip conditions in longitudinal cases
	   local numSkips = 0
	   //iterate through all waves
	   forvalues wave = 1/`numWaves'{
		   if("`longitudinal'" != ""){
				quietly levelsof `var' if `id_wave' == `wave', clean
		   }
		   else {
				quietly levelsof `var' if `varName' == `varNum', clean
		   }
		   
		   
		   local toPrintValue = "`r(levels)'"
		   //if variable has no labelbook
		   if(`"`varlabel'"' == ""){
				if `"`ignore'"' != "" {
					foreach skip of local ignore {
						if("`r(levels)'" == "`skip'"){
							local numSkips = `numSkips' + 1
							continue, break
						}
					}
				}
		   }
		   else {
				//account for missing values in labelbook
				if("`r(levels)'"==""){
					if("`longitudinal'" != ""){
						quietly levelsof `var' if `id_wave' == `wave', missing
					}
					else{
						quietly levelsof `var' if `varName' == `varNum', missing
					}
					
				}
				local toPrintValue : label `varlabel' `r(levels)', strict
				//get rid of special character that cannot be outputted
				local toPrintValue : subinstr local toPrintValue "`=char(96)'" "`=uchar(8219)'", all
				if  "`r(levels)'" != "" & "`toPrintValue'"=="" {
					local toPrintValue = "`r(levels)'"
				}
		   }
		   
		   //drop unwanted responses
		   if "`empty'"!="" & (regexm("`toPrintValue'", "(^\.[a-z]?$)|(^\s*$)")){
				local numSkips = `numSkips' + 1
		   }
		   else if (`"`ignore'"' != "") {
			   foreach skip of local ignore {
				   if("`toPrintValue'" == "`skip'"){
					   local numSkips = `numSkips' + 1
					   continue, break
				   }
			   }
		   }		   
		  
			//print value
			local col = `wave'+2
			`doccmd' table tbl(`i', `col') = ("`toPrintValue'")
	   
	   }
	   
		
		if(`numSkips' == `numWaves'){
			`doccmd' table tbl(`i', .), drop
			local i = `i' - 1
		}
		else {
			   // variable name
			   local toPrintVar = `"`var'"'
			   local toPrintVar : subinstr local toPrintVar "`=char(96)'" "`=uchar(8219)'", all
			   `doccmd' table tbl(`i', 1) = (`"`toPrintVar'"')

			   //variable label
			   local label : variable label `var'
			   local toPrintLabel = `"`label'"'
			   local toPrintLabel : subinstr local toPrintLabel "`=char(96)'" "`=uchar(8219)'", all
			   if("`addnotes'"!=""){
					local toPrintNote : char `var'[note1]
					if("`toPrintNote'"!=""){
						local toPrintNote = "N: `toPrintNote'"
						`doccmd' table tbl(`i', 2) = ("`toPrintLabel'"), linebreak
						`doccmd' table tbl(`i', 2) = ("`toPrintNote'"), append font("`docFont'", 9)
					}
					else{
						`doccmd' table tbl(`i', 2) = ("`toPrintLabel'")
					}
			   }
			   else{
					`doccmd' table tbl(`i', 2) = ("`toPrintLabel'")
			   }
			   
		 }
	   
       local i = `i'+1
    }
	
	//filename and location options
	local temp_replace = ""
	if("`replace'"!=""){
		local temp_replace = "replace"
	}
	
	if("`fileName'"!=""){
		`doccmd' save "`fileName'", `temp_replace'
	}
	else{
		`doccmd' save "`varName'`varNum'", `temp_replace'
	}
end
