#!/bin/bash
run_timestamp=$(date +'%Y-%m-%d %H:%M:%S')

# MySQL connection parameters
mysql_host="localhost"
mysql_user="neo4j"
mysql_password="Neo4jCypher!"
mysql_database="CypherInjection"

# Define pfSense SSH connection parameters
pfsense_host="10.0.0.254"
pfsense_user="admin"
pfsense_password="Neo4jCypher!"

# SSH command to retrieve the most recent Snort alert with a sid of 10000+ on interface LAN1
ssh_command="cat /var/log/snort/snort_em147541/alert | grep 10000 | tail -n 1"

# SQL query to retrieve all Cypher query test cases
selectAllTestCasesQuery="select QueryId, QueryTxt from CypherInjection.CypherQuery;"

#initialize pfSense alert variables
previous_snort_alert=""
snort_alert=""
injectionDetectedInd=0

#retrieve all test cases and store them in an array
mapfile -t results < <(mysql -h "$mysql_host" -u "$mysql_user" -p"$mysql_password" "$mysql_database" -s -N -e "$selectAllTestCasesQuery") 

# for each test case, run the cypher, retrieve the latest detection from PFSense, and store the results in the Observations table

for row in "${results[@]}"; do
	IFS=$'\t' read -r QueryId QueryTxt <<< "$row"
    	echo "QueryId: $QueryId, QueryTxt: $QueryTxt"

    	# Construct the output file name with current timestamp
    	output_file="/var/cypherinjectiondetection/testOutput/$(date +%Y%m%d%H%M%S).txt"

	# Run the cypher query, recording the output and the duration
	start_time=$(date +%s%3N)
	cypher-shell -a 192.168.3.6 -u neo4j -p Neo4jCypher! -d neo4j "$QueryTxt"  > "$output_file"
	end_time=$(date +%s%3N)
	durationMs=$((end_time - start_time))
	cypherOutput=$(<"$output_file")
	cypherOutput="${cypherOutput:0:4000}"
	cypherOutput="${cypherOutput//\'/\`}"
	
	#wait for the snort log to catch up
	sleep 5
	
	# Connect to pfSense via SSH and retrieve the most recent Snort alert
	previous_snort_alert=$snort_alert
	snort_alert=$(sshpass -p "$pfsense_password" ssh -o StrictHostKeyChecking=no "$pfsense_user@$pfsense_host" "$ssh_command")
	echo "previous_snort_alert"
	echo "$previous_snort_alert"
	echo "snort_alert"
	echo "$snort_alert"
	if [[ "$snort_alert" != "$previous_snort_alert" && ! -z "$previous_snort_alert" ]]; then

		injectionDetectedInd=1
		detectionTxt=$snort_alert
	else
		injectionDetectedInd=0
		detectionTxt=""
	fi

	# SQL insert to store test results
	insert_query="INSERT INTO CypherInjection.Observation (ObservationTs, RunTs, QueryId, ResponseTxt, DetectionTxt, DetectedInd, DurationMs) VALUES (current_timestamp(),'${run_timestamp}',$QueryId,'$cypherOutput','$detectionTxt',$injectionDetectedInd, $durationMs);"
		
	# Execute the insert command
	mysql -h "$mysql_host" -u "$mysql_user" -p"$mysql_password" "$mysql_database" -e "$insert_query"
	
	# Check if the command was successful
	if [ $? -eq 0 ]; then
	    echo "Command successful"
	else
	    echo "Error running command for $insert_query"
	fi
done

#summary
summarySQL="select case when a.InjectionQueryInd = 1 and b.DetectedInd = 1 then 'True Positive' when a.InjectionQueryInd = 1 and b.DetectedInd = 0 then 'False Negative' when a.InjectionQueryInd = 0 and b.DetectedInd = 1 then 'False Positive' when a.InjectionQueryInd = 0 and b.DetectedInd = 0 then 'True Negative' else 'unknown' end as DetectionCategory, count(b.ObservationId) as Cnt from Observation b INNER JOIN CypherQuery a ON a.QueryId = b.QueryId WHERE b.RunTs = '${run_timestamp}' group by case when a.InjectionQueryInd = 1 and b.DetectedInd = 1 then 'True Positive' when a.InjectionQueryInd = 1 and b.DetectedInd = 0 then 'False Negative' when a.InjectionQueryInd = 0 and b.DetectedInd = 1 then 'False Positive' when a.InjectionQueryInd = 0 and b.DetectedInd = 0 then 'True Negative' else 'unknown' end"
        
mysql -h "$mysql_host" -u "$mysql_user" -p"$mysql_password" "$mysql_database" -e "$summarySQL"