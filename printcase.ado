//MADE BY MAX WEINREB
program printcase
    version 16.0

	syntax anything(id="ID Variable and ID Value"), [pdf file(string) location(string) font(string) noempty noreplace]
	tokenize `anything'
	local varName `1'
	local varNum `2'
    //Setting up documents, either pdf or word
    
	display "ID Variable: `varName'"
	display "ID Value: `varNum'"
	
	if("`font'" == "") {
		local docFont = "Calibri"
	}
	else {
		local docFont = "`font'"
	}
	local indexSlash = strrpos("`c(filename)'", "\") 
	local myFile = substr("`c(filename)'", `indexSlash'+1, strlen("`c(filename)'")-`indexSlash')
	if("`pdf'"!=""){
		putpdf clear
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
		
		putpdf paragraph
	}
	else{
		putdocx clear
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
		
		putdocx paragraph
	}

	

    //Retreiving list of variables
    quietly describe, varlist
	local dataVars  `r(varlist)'
    local rowNum = `r(k)'
    local ++rowNum
    //Making Table based on number of variables, with column titles
	if("`pdf'"!=""){
		putpdf table tbl = (`rowNum', 3)
		putpdf table tbl(1,1) = ("Variable Name")
		putpdf table tbl(1,2) = ("Variable Label")
		putpdf table tbl(1,3) = ("Response Value")
	}
	else{
		putdocx table tbl = (`rowNum', 3)
		putdocx table tbl(1,1) = ("Variable Name")
		putdocx table tbl(1,2) = ("Variable Label")
		putdocx table tbl(1,3) = ("Response Value")
	}
    
	
    local i = 2
    foreach var in `dataVars' {
	   //Response for case
	   local skipRow = 0
	   local varlabel : value label `var'
       quietly levelsof `var' if `varName' == `varNum', clean missing
	   //if variable has no labelbook
	   if(`"`varlabel'"' == ""){
			if "`empty'"!="" & (regexm("`r(levels)'", "(^\.[a-z]?$)|(^\s*$)")) {
				if("`pdf'"!=""){
					putpdf table tbl(`i', .), drop
				}
				else{
					putdocx table tbl(`i', .), drop
				}
				local i = `i'-1
				local skipRow = 1
			} 
			if `skipRow' != 1 {
				local toPrint = `"`r(levels)'"'
				if("`pdf'"!=""){
					putpdf table tbl(`i', 3) = (`"`toPrint'"')
				}
				else{
					putdocx table tbl(`i', 3) = (`"`toPrint'"')
				}
			}
	   }
	   else {
			local value_label : label `varlabel' `r(levels)', strict
			local value_label : subinstr local value_label "`=char(96)'" "`=uchar(8219)'", all
			if "`value_label'"!=""{
			}
			else if "`r(levels)'" != "" & "`value_label'"=="" {
				local value_label = "`r(levels)'"
			}
			if "`empty'"!="" & (regexm("`value_label'", "(^\.[a-z]?$)|(^\s*$)")) {
				if("`pdf'"!=""){
					putpdf table tbl(`i', .), drop
				}
				else{
					putdocx table tbl(`i', .), drop
				}
				local i = `i'-1
				local skipRow = 1
			}
			if(`skipRow' != 1){
				if("`pdf'"!=""){
					putpdf table tbl(`i', 3) = (`"`value_label'"')
				}
				else{
					putdocx table tbl(`i', 3) = (`"`value_label'"')
				}
			}
	   }
	   
	   if(`skipRow' == 0) {
		   // variable name
		   local toPrintVar = `"`var'"'
		   local toPrintVar : subinstr local toPrintVar "`=char(96)'" "`=uchar(8219)'", all
		   if("`pdf'"!=""){
			putpdf table tbl(`i', 1) = (`"`toPrintVar'"')
		   }
		   else{
			putdocx table tbl(`i', 1) = (`"`toPrintVar'"')
		   }
		   

		   //variable label
		   local label : variable label `var'
		   local toPrintLabel = `"`label'"'
		   local toPrintLabel : subinstr local toPrintLabel "`=char(96)'" "`=uchar(8219)'", all
		   if("`pdf'"!=""){
		   	putpdf table tbl(`i', 2) = (`"`toPrintLabel'"')
		   }
		   else{
		   	putdocx table tbl(`i', 2) = (`"`toPrintLabel'"')
		   }
		   
	   }
	   
       local i = `i'+1
    }
	
	//filename and location options
	local temp_replace = "replace"
	if("`replace'"!=""){
		local temp_replace = ""
	}
	if "`file'" == "" & "`location'" == ""{
		if("`pdf'"!=""){
			putpdf save "`varName'`varNum'.pdf", `temp_replace'
		}
		else{
			putdocx save "`varName'`varNum'.docx", `temp_replace'
		}
		
	}
    else if "`file'" == "" & "`location'" != "" {
		if("`pdf'"!=""){
			putpdf save "`location'/`varName'`varNum'", `temp_replace'
		}
		else{
			putdocx save "`location'/`varName'`varNum'", `temp_replace'
		}
	}
	else if "`file'" != "" & "`location'" == "" {
		if("`pdf'"!=""){
			putpdf save "`file'", `temp_replace'
		}
		else{
			putdocx save "`file'", `temp_replace'
		}
		
	}
	else {
		if("`pdf'"!=""){
			putpdf save "`location'/`file'", `temp_replace'
		}
		else{
			putdocx save "`location'/`file'", `temp_replace'
		}
		
	}
end
