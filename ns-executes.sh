#!/bin/bash 
 
# Check parameters 
if [[ "$#" -ne 3 ]]; then 
    echo "3 parameters required" 
    exit 0 
fi 
 
# Translate lesson name into correct name for Workshopper projects 
if [ $2 == "fulfill_a_promise" ]; then 
    STR="FULFILL A PROMISE" 
elif [ $2 == "reject_a_promise" ]; then 
    STR="REJECT A PROMISE" 
elif [ $2 == "to_reject_or_not_to_reject" ]; then 
    STR="TO REJECT OR NOT TO REJECT" 
elif [ $2 == "always_async" ]; then 
    STR="ALWAYS ASYNC" 
elif [ $2 == "values_and_promises" ]; then 
    STR="VALUES AND PROMISES" 
elif [ $2 == "throw_an_error" ]; then 
    STR="THROW AN ERROR" 
elif [ $2 == "using_qfcall" ]; then 
    STR="USING QFCALL" 
elif [ $2 == "an_important_rule" ]; then 
    STR="AN IMPORTANT RULE" 
elif [ $2 == "multiple_promises" ]; then 
    STR="MULTIPLE PROMISES" 
elif [ $2 == "fetch_json" ]; then 
    STR="FETCH JSON" 
elif [ $2 == "do_some_work" ]; then 
    STR="DO SOME WORK" 
elif [ $2 == "more_functional" ]; then 
    STR="MORE FUNCTIONAL" 
else 
    echo UNKNOWN: Make sure you have your code file selected before running/verifying 
    exit 0 
fi 
echo SELECTED FILE IS : $STR 
 
#Select the workshopper lesson 
promise-it-wont-hurt select $STR > /dev/null 
 
# Run or Verify? 
if [ $1 == "run" ]; then 
    promise-it-wont-hurt run $3/$2.js 
elif [ $1 == "verify" ]; then 
    promise-it-wont-hurt verify $3/$2.js 
else  
    echo "BAD COMMAND" 
fi