# caseToASCIIreplacement
Replace national characters or other unwanted chars to ASCII set, trim repeated chars

#\#\# Replace Cases ver 1.6 \#\##

 + added trimming connectors space
 + added "key char" to trimming table
 + added switch -dontTouchSpaces
 
### How to use:
   `replace-Cases "string to replace" [-replaceSpecialChars] [-reloadTable] [-trim [-trimSeparators [main_separator,char_toRemove1,char_ToRemove2, ... ]]`

 * replaceSpecialChars : will replace chars with the pattern stored in the special chars csv file
 * dontTouchSpaces : will replace special chars but without replacing spaces
 * reloadTable : will reload replacemen data source when function called
 
 		-if omitted, only first execution will load the data table
 * trim : if trimSeparators table is not present, will remove unnecessary spaces
 * trimSeparators : will trim the data from doubled spaces if no values entered

		if entered characters table, the first char (zero position) will be set as the leading character
		next chars from the table will be removed from the surrounding of the leading character
		repetitions of chars from the table will be reduced to one between "words" (other chains)
 
### Requirements

For proper work, the script needs two files with a character set - one to replace diacritics, the other to replace special characters (actually, you can use both interchangeably). Sample files (ready for everyday work) have been attached to the repository.

### Samples
```
replace-Cases "  Ala - ta żółta krówa - ma_kota, a  kot _ma_ wywalone._"
returns:    Ala - ta zoulta krouwa - ma_kota, a  kot _ma_ wywalone._ 

replace-Cases "  Ala - ta żółta krówa - ma_kota, a  kot _ma_ wywalone._" -replaceSpecialChars
returns:  __Ala_-_ta_żółta_krówa_-_ma_kota_a__kot__ma__wywalone_ 

replace-Cases (replace-Cases "  Ala - ta żółta krówa - ma_kota, a  kot _ma_ wywalone._") -replaceSpecialChars
returns:  __Ala_-_ta_zoulta_krouwa_-_ma_kota_a__kot__ma__wywalone_

replace-Cases "  Ala - ta żółta krówa - ma_kota, a  kot _ma_ wywalone._" -trim
returns:  Ala - ta zoulta krouwa - ma_kota, a kot _ma_ wywalone._

replace-Cases "  Ala - ta żółta krówa - ma_kota, a  kot _ma_ wywalone._" -trim @("-"," ","_")
returns:  Ala-ta zoulta krouwa-ma_kota, a kot ma_wywalone.

replace-Cases "  Ala - ta żółta krówa - ma_kota, a  kot _ma_ wywalone._" -replaceSpecialChars -trim @("-"," ","_")
returns:  Ala-ta_żółta_krówa-ma_kota_a_kot_ma_wywalone

replace-Cases "  Ala - ta żółta krówa - ma_kota, a  kot _ma_ wywalone._" -replaceSpecialChars -trim @("-"," ","_") -dontTouchSpaces
returns:  Ala-ta żółta krówa-ma_kota a kot ma_wywalone
```
