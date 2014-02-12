#!/bin/bash 
 
# Check parameters 
if [[ "$#" -ne 3 ]]; then 
    echo "3 parameters required" 
    exit 0 
fi 
 
# Translate lesson name into correct name for Workshopper projects 
if [ $2 == "fulfill_a_promise" ]; then 
    STR=" fulfill a promise" 
elif [ $2 == "reject_a_promise" ]; then 
    STR=" reject a promise" 
elif [ $2 == "to_reject_or_not_to_reject" ]; then 
    STR=" to reject or not to reject" 
elif [ $2 == "always_async" ]; then 
    STR=" always async" 
elif [ $2 == "values_and_promises" ]; then 
    STR=" values and promises" 
elif [ $2 == "throw_an_error" ]; then 
    STR=" throw an error" 
elif [ $2 == "using_qfcall" ]; then 
    STR=" using qfcall" 
elif [ $2 == "an_important_rule" ]; then 
    STR=" an important rule" 
elif [ $2 == "multiple_promises" ]; then 
    STR=" multiple promises" 
elif [ $2 == "fetch_json" ]; then 
    STR=" fetch json" 
elif [ $2 == "do_some_work" ]; then 
    STR=" do some work" 
elif [ $2 == "more_functional" ]; then 
    STR=" more functional" 
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