mysqlimport --user root -pchangeme --local --replace --ignore-lines 1 --fields-terminated-by=, ibusdb user.csv -c first_name,last_name,email
mysqlimport --user root -pchangeme --local --replace --ignore-lines 1 --lines-terminated-by="\r\n" --fields-terminated-by=, ibusdb printrequests.csv -c name,filepath,description,user_id

pause