//MADE BY MAX WEINREB
program printcase
    version 16.0

	syntax anything [if] [in] [, pdf file(string) location(string) font(string) noempty noanswer(string asis) ]
	tokenize `anything'
	local varName `1'
	local varNum `2'
    //Setting up word documents, either pdf or word
    
	
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
		
		//Pagenumbers + footer1
// 		putpdf paragraph
// 		putpdf pagenumber
// 		putpdf text("		printcase_`varNum'_`myFile'")
		
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
			if "`empty'"!="" & ("`r(levels)'" == "." | "`r(levels)'" == "") {
				if("`pdf'"!=""){
					putpdf table tbl(`i', .), drop
				}
				else{
					putdocx table tbl(`i', .), drop
				}
				local i = `i'-1
				local skipRow = 1
			} 
			else if `"`noanswer'"' != "" {
				foreach ignore of local noanswer {
					if(`"`r(levels)'"' == `"`ignore'"'){
						if("`pdf'"!=""){
							putpdf table tbl(`i', .), drop
						}
						else{
							putdocx table tbl(`i', .), drop
						}
						local i = `i'-1
						local skipRow = 1
					}
				}
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
			if "`empty'"!="" & ("`value_label'" == "." | "`value_label'" == "") {
				if("`pdf'"!=""){
					putpdf table tbl(`i', .), drop
				}
				else{
					putdocx table tbl(`i', .), drop
				}
				local i = `i'-1
				local skipRow = 1
			}
			else if `"`noanswer'"' != "" {
				foreach ignore of local noanswer {
					if("`value_label'" == `"`ignore'"'){
						if("`pdf'"!=""){
							putpdf table tbl(`i', .), drop
						}
						else{
							putdocx table tbl(`i', .), drop
						}
						local i = `i'-1
						local skipRow = 1
					}
				}
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
	
	//filename andd location options
	if "`file'" == "" & "`location'" == ""{
// 		display "Printed contents of `varName' `varNum' in `c(pwd)'/`varName'`varNum'.docx"
		if("`pdf'"!=""){
			putpdf save "`varName'`varNum'.pdf", replace
		}
		else{
			putdocx save "`varName'`varNum'.docx", replace
		}
		
	}
    else if "`file'" == "" & "`location'" != "" {
// 		display "Printed contents of `varName' `varNum' in `location'/`varName'`varNum'.docx"
		if("`pdf'"!=""){
			putpdf save "`location'/`varName'`varNum'", replace
		}
		else{
			putdocx save "`location'/`varName'`varNum'", replace
		}
	}
	else if "`file'" != "" & "`location'" == "" {
// 		display "Printed contents of `varName' `varNum' in `c(pwd)'/`file'.docx"
		if("`pdf'"!=""){
			putpdf save "`file'", replace
		}
		else{
			putdocx save "`file'", replace
		}
		
	}
	else {
// 		display "Printed contents of `varName' `varNum' in `location'/`file'.docx"
		if("`pdf'"!=""){
			putpdf save "`location'/`file'", replace
		}
		else{
			putdocx save "`location'/`file'", replace
		}
		
	}
end
