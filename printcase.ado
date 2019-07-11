program printcase
    version 16.0

    //command is in format variableName variableNum
    args varName varNum
    confirm number `varNum'

    //Setting up word document with title
    putdocx clear
    putdocx begin
    putdocx paragraph, style(Title)
    putdocx text ("Case `varNum'")
    putdocx paragraph


    //Retreiving list of variables
    quietly describe, varlist
    local rowNum = `r(k)'
    local ++rowNum

    //Making Table based on number of variables, with column titles
    putdocx table tbl = (`rowNum', 3)
    putdocx table tbl(1,1) = ("Variable Name")
    putdocx table tbl(1,2) = ("Variable Value")
    putdocx table tbl(1,3) = ("Variable Label")

    //Printing variable names to doc
    //Printing variable label to doc
    local i = 2
    foreach var in `r(varlist)' {

       // variable name
       putdocx table tbl(`i', 1) = ("`var'")

       //variable label
       local label : variable label `var'
       putdocx table tbl(`i', 2) = ("`label'")

       //variable value for case
       quietly levelsof `var' if `varName' == `varNum', clean missing
       capture confirm numeric variable `var'
       if !_rc{
           local value_label : label `var' `r(levels)', strict
           if "`value_label'" == "" {
                putdocx table tbl(`i', 3) = ("`r(levels)'")
           }
           else {
                putdocx table tbl(`i', 3) = ("`value_label'")
           }
       }
       else {
           putdocx table tbl(`i', 3) = ("`r(levels)'")
       }
       local i = `i'+1
    }

    display "Printed contents of `varName' `varNum' in `c(pwd)'\case`varNum'.docx"
    putdocx save "case`varNum'.docx", replace
end