//MADE BY MAX WEINREB
program printcase
    version 16.0

    //command is in format variableName variableNum
	syntax anything [if] [in] [, file(string) location(string) font(string) noempty noanswer(string asis) ]
	tokenize `anything'
	local varName `1'
	local varNum `2'
    //Setting up word document with title
    putdocx clear
	
	if("`font'" == "") {
		local docFont = "Calibri"
	}
	else {
		local docFont = "`font'"
	}
	putdocx begin, pagenum(decimal) footer(footer1) font("`docFont'")
    //Title
    putdocx paragraph, style(Title) 
    putdocx text (`"`varName' `varNum'"'), font("`docFont'")

    //Extracting Filename
	local indexSlash = strrpos("`c(filename)'", "\") 
	local myFile = substr("`c(filename)'", `indexSlash'+1, strlen("`c(filename)'")-`indexSlash')
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
	
    putdocx paragraph

    //Retreiving list of variables
    quietly describe, varlist
	local dataVars  `r(varlist)'
    local rowNum = `r(k)'
    local ++rowNum
    //Making Table based on number of variables, with column titles
    putdocx table tbl = (`rowNum', 3)
    putdocx table tbl(1,1) = ("Variable Name")
    putdocx table tbl(1,2) = ("Variable Label")
    putdocx table tbl(1,3) = ("Response Value")
	
    local i = 2
    foreach var in `dataVars' {
	   //Response for case
	   local skipRow = 0
	   local varlabel : value label `var'
       quietly levelsof `var' if `varName' == `varNum', clean missing
	   //if variable has no labelbook
	   if(`"`varlabel'"' == ""){
			if "`empty'"!="" & ("`r(levels)'" == "." | "`r(levels)'" == "") {
				putdocx table tbl(`i', .), drop
				local i = `i'-1
				local skipRow = 1
			} 
			else if `"`noanswer'"' != "" {
				foreach ignore of local noanswer {
					if(`"`r(levels)'"' == `"`ignore'"'){
						putdocx table tbl(`i', .), drop
						local i = `i'-1
						local skipRow = 1
					}
				}
			}
			if `skipRow' != 1 {
				putdocx table tbl(`i', 3) = (`"`r(levels)'"')
			}
	   }
	   else {
			local value_label : label `varlabel' `r(levels)', strict
			local finalLabel = ""
			if "`value_label'"!=""{
				local finalLabel = "`value_label'"
			}
			else if "`r(levels)'" != "" & "`value_label'"=="" {
				local finalLabel = "`r(levels)'"
			}
			if "`empty'"!="" & ("`finalLabel'" == "." | "`finalLabel'" == "") {
				putdocx table tbl(`i', .), drop
				local i = `i'-1
				local skipRow = 1
			}
			else if `"`noanswer'"' != "" {
				foreach ignore of local noanswer {
					if("`finalLabel'" == `"`ignore'"'){
						putdocx table tbl(`i', .), drop
						local i = `i'-1
						local skipRow = 1
					}
				}
			}
			if(`skipRow' != 1){
				putdocx table tbl(`i', 3) = ("`finalLabel'")
			}
	   }
	   
	   if(`skipRow' == 0) {
		   // variable name
		   putdocx table tbl(`i', 1) = (`"`var'"')

		   //variable label
		   local label : variable label `var'
		   putdocx table tbl(`i', 2) = (`"`label'"')
	   }
	   
       local i = `i'+1
    }
	
	//filename andd location options
	if "`file'" == "" & "`location'" == ""{
		display "Printed contents of `varName' `varNum' in `c(pwd)'\\`varName'`varNum'.docx"
		putdocx save "`varName'`varNum'.docx", replace
	}
    else if "`file'" == "" & "`location'" != "" {
		display "Printed contents of `varName' `varNum' in `location'/`varName'`varNum'.docx"
		putdocx save "`location'/`varName'`varNum'", replace
	}
	else if "`file'" != "" & "`location'" == "" {
		display "Printed contents of `varName' `varNum' in `c(pwd)'/`file'.docx"
		putdocx save "`file'", replace
	}
	else {
		display "Printed contents of `varName' `varNum' in `location'/`file'.docx"
		putdocx save "`location'/`file'", replace
	}
end