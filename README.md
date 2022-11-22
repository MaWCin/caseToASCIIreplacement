# caseToASCIIreplacement
Replace national characters or other unwanted chars to ASCII set, trim repeated chars

#\#\# Replace Cases ver 1.6 \#\##

 + added trimming connectors space
 + added "key char" to trimming table
 + added switch -dontTouchSpaces
 
### How to use:
   `replace-Cases "string to replace" [-replaceSpecialChars] [-reloadTable] [-trim [-trimSeparators [main_separator,char_toRemove1,char_ToRemove2, ... ]]`

 [ ] replaceSpecialChars : will replace chars with the pattern stored in the special chars csv file
 [ ] dontTouchSpaces : will replace special chars but without replacing spaces
 [ ] reloadTable : will reload replacemen data source when function called
				-if omitted, only first execution will load the data table
 [ ] trim : if trimSeparators table is not present, will remove unnecessary spaces
 [ ] trimSeparators : will trim the data from doubled spaces if no values entered
					if entered characters table, the first char (zero position) will be set as the leading character
					next chars from the table will be removed from the surrounding of the leading character
					repetitions of chars from the table will be reduced to one between "words" (other chains)
 
