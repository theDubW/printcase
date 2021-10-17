//MADE BY MAX WEINREB
program printcase
    version 17.0

	syntax [using/] if/ =/exp, [pdf font(string) noempty ignore(string) replace addnotes longitudinal(integer 1)]
	
	local varName `if'
	
	local varNum `exp'
	local fileName `using'
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

	
    //Making Table based on number of variables, with column titles
	local numColumns = `longitudinal'+2
	`doccmd' table tbl = (`rowNum', `numColumns')
	`doccmd' table tbl(1,1) = ("Variable Name")
	`doccmd' table tbl(1,2) = ("Variable Label")
	
	//if longitudinal generate more response columns
	local col = 3
	if("`longitudinal'" != ""){
		while (`col' <= `numColumns'){
			local col = `col'-2
			local result = "Response (wave "
			local result = "`result'" + "`col'" + ")"
			local col = `col' + 2
 			`doccmd' table tbl(1,`col') = ("`result'")
			local col = `col' + 1
		}
	} 
	else {
		`doccmd' table tbl(1, 3) = ("Response")
	}
	

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
				local toPrint = `"`r(levels)'"'
				local col = 3
				foreach response in `r(levels)' {
					`doccmd' table tbl(`i', `col') = ("`response'")
					local col = `col' + 1
				}
				
			}
	   }
	   else {
			//account for missing values in labelbook
			if("`r(levels)'"==""){
				quietly levelsof `var' if `varName' == `varNum', clean missing
			}
			local col = 3
			foreach response in `r(levels)'{
				
				local value_label : label `varlabel' `response', strict
				local value_label : subinstr local value_label "`=char(96)'" "`=uchar(8219)'", all
				if "`value_label'"!=""{
				}
				else if "`response'" != "" & "`value_label'"=="" {
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
					`doccmd' table tbl(`i', `col') = (`"`value_label'"')
				}
				
				local col = `col'+1
				
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
	
	if("`using'"!=""){
		`doccmd' save "`using'", `temp_replace'
	}
	else{
		`doccmd' save "`varName'`varNum'", `temp_replace'
	}
end
