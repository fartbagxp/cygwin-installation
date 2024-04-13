# Dug

- [Worldwide DNS servers](https://github.com/unfrl/dug/blob/main/cli/Resources/default_servers.csv)

unfrl-dug vaccines.gov --retries 10 --server-count 500 --output-format CSV --output-template ipaddress,countrycode,city,dnssec,reliability,continentcode,countryname,countryflag,citycountryname,citycountrycontinentname,responsetime,recordtype,haserror,errormessage,errorcode,value > vaccines.gov-output.csv
