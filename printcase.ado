//MADE BY MAX WEINREB
program printcase
    version 17.0

	syntax anything(everything id = "if id_variable == id_val"), [pdf font(string) noempty ignore(string) replace addnotes]
	tokenize `anything'
	local fileName = ""
	local varName = ""
	local varNum = ""
	
	if("`1'" != "using" & "`1'" != "if"){
		display "Must follow printcase syntax"
		error 198
	} 
	else if("`1'" == "if"){
		local varName `2'
		if("`3'" != "=="){
			display "Must have '==' expression"
			error 198 
		}
		if("`4'" == ""){
			display "Cannot have empty id_val"
			error 198
		}
		local varNum `4'
	} 
	else {
		local fileName = "`2'"
		if("`3'" != "if"){
			display "Must have if expression"
			error 198 
		}
		local varName `4'
		if("`5'" != "=="){
			display "Must have '==' expression"
			error 198
		}
		if("`6'" == ""){
			display "Cannot have empty id_val"
			error 198
		}
		local varNum `6'
	}
	//checking for extra unnecessary arguments
	if("`fileName'" != ""){
		if("`7'" != ""){
			display "Too many arguments passed"
			error 198
		} 
	}
	else{
		if("`5'" != ""){
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
	
	
	//Title and setting up document
	if("`pdf'"!=""){
		putpdf begin, font("`docFont'")
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
		putdocx begin, pagenum(decimal) footer(footer1) font("`docFont'")
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

    //Initializing table
	`doccmd' table tbl = (`rowNum', 3)
	`doccmd' table tbl(1,1) = ("Variable Name")
	`doccmd' table tbl(1,2) = ("Variable Label")
	`doccmd' table tbl(1, 3) = ("Response")
	

    local i = 2
    foreach var in `dataVars' {
	   //Response for case
	   local skipRow = 0
	   local varlabel : value label `var'
       quietly levelsof `var' if `varName' == `varNum', clean
	   //if variable has no labelbook
	   if(`"`varlabel'"' == ""){
			
			if "`empty'"!="" & (regexm("`r(levels)'", "(^\.[a-z]?$)|(^\s*$)")) {
				`doccmd' table tbl(`i', .), drop
				local i = `i'-1
				local skipRow = 1
			}
			else if `"`ignore'"' != "" {
				foreach skip of local ignore {
					if(`"`r(levels)'"' == `"`skip'"'){
						`doccmd' table tbl(`i', .), drop
						local i = `i'-1
						local skipRow = 1
					}
				}
			}
			if `skipRow' != 1 {
				`doccmd' table tbl(`i', 3) = ("`r(levels)'")
			}
	   }
	   else {
			//account for missing values in labelbook
			if("`r(levels)'"==""){
				quietly levelsof `var' if `varName' == `varNum', missing
			}
			
			local value_label : label `varlabel' `r(levels)', strict
			local value_label : subinstr local value_label "`=char(96)'" "`=uchar(8219)'", all
			if  "`response'" != "" & "`value_label'"=="" {
				local value_label = "`response'"
			}
			if "`empty'"!="" & (regexm("`value_label'", "(^\.[a-z]?$)|(^\s*$)")) {
				`doccmd' table tbl(`i', .), drop
				local i = `i'-1
				local skipRow = 1
			}
			else if `"`ignore'"' != "" {
				foreach skip of local ignore {
					if("`value_label'" == `"`skip'"'){
						`doccmd' table tbl(`i', .), drop
						local i = `i'-1
						local skipRow = 1
					}
				}
			}
			if(`skipRow' != 1){
				`doccmd' table tbl(`i', 3) = ("`value_label'")
			}		
		
	   }
	   
	   if(`skipRow' == 0) {
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
