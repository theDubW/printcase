//MADE BY MAX WEINREB
program printcase
    version 16.0

    //command is in format variableName variableNum
	syntax anything [if] [in] [, file(string) location(string) font(string) noempty noanswer(string) ]
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
    putdocx text ("`varName' `varNum'"), font("`docFont'")

    //Extracting Filename
	local indexSlash = strrpos("`c(filename)'", "\") 
	local filename = substr("`c(filename)'", `indexSlash'+1, strlen("`c(filename)'")-`indexSlash'-1)
	putdocx paragraph, style(Heading1) 
	putdocx text ("User: `c(username)'"), font("`docFont'")
	putdocx paragraph, style(Heading1)
    putdocx text ("Dataset: `filename'"), font("`docFont'")
	putdocx paragraph, style(Heading1)
	putdocx text ("Date of Printing: `c(current_date)'"), font("`docFont'")
	
	//Pagenumbers + footer1
	putdocx paragraph, tofooter(footer1)
	putdocx pagenumber
	putdocx text ("		printcase_`varNum'_`filename'")
	
	
    putdocx paragraph

    //Retreiving list of variables
    quietly describe, varlist
    local rowNum = `r(k)'
    local ++rowNum

    //Making Table based on number of variables, with column titles
    putdocx table tbl = (`rowNum', 3)
    putdocx table tbl(1,1) = ("Variable Name")
    putdocx table tbl(1,2) = ("Variable Label")
    putdocx table tbl(1,3) = ("Response Value")

    //Printing variable names to doc
    //Printing variable label to doc
    local i = 2
    foreach var in `r(varlist)' {
	
	   //Response for case
	   local skipRow = 0
	   local varlabel : value label `var'
       quietly levelsof `var' if `varName' == `varNum', clean missing
	   //if variable has no labelbook
	   if("`varlabel'" == ""){
			putdocx table tbl(`i', 3) = ("`r(levels)'")
	   }
	   else {
			local value_label : label `varlabel' `r(levels)', strict
			if "`empty'"!="" & "`value_label'" == ""{
				putdocx table tbl(`i', .), drop
				local i = `i'-1
				local skipRow = 1
			}
			else if "`noanswer'" == "`value_label'" {
				putdocx table tbl(`i', .), drop
				local i = `i'-1
				local skipRow = 1
			}
			else {
				putdocx table tbl(`i', 3) = ("`value_label'")
			}
	   }
	   if(`skipRow' == 0) {
		   // variable name
		   putdocx table tbl(`i', 1) = ("`var'")

		   //variable label
		   local label : variable label `var'
		   putdocx table tbl(`i', 2) = ("`label'")
	   }

       local i = `i'+1
    }
	
	//filename andd location options
	if "`file'" == "" & "`location'" == ""{
		display "Printed contents of `varName' `varNum' in `c(pwd)'\\`varName'`varNum'.docx"
		putdocx save "`varName'`varNum'.docx", replace
	}
    else if "`file'" == "" & "`location'" != "" {
		display "Printed contents of `varName' `varNum' in `location'\\`varName'`varNum'.docx"
		putdocx save "`location'\\`varName'`varNum'", replace
	}
	else if "`file'" != "" & "`location'" == "" {
		display "Printed contents of `varName' `varNum' in `c(pwd)'\\`file'.docx"
		putdocx save "`file'", replace
	}
	else {
		display "Printed contents of `varName' `varNum' in `location'\\`file'.docx"
		putdocx save "`location'\\`file'", replace
	}
end