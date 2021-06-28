#!/bin/bash

rm -Rf ./sc_tag_testrun.json
rm -Rf ./ids_scenarios.json
rm -Rf ./test_run_id.json

TAG_KEY="RegressionALL"

# echo "Getting all scenarios with $TAG_KEY tag from project ID: $PROJECT_ID"
response=$(curl -sS "https://app.hiptest.com/api/projects/$PROJECT_ID/scenarios/find_by_tags?key=$TAG_KEY" \
  -H "accept: application/vnd.api+json; version=1" \
  -H "access-token: $API_ACCESS_TOKEN" \
  -H "uid: $API_UID" \
  -H "client: $API_CLIENT" \
  -o ./sc_tag_testrun.json \
  -w %{http_code})

if [[ $? -eq 0 && $response =~ ^2 ]]; then

  readarray -t scenario_ids < <(jq -r '.data[].id' ./sc_tag_testrun.json)

  n=${#scenario_ids[@]}
  last=$(( ${#scenario_ids[*]} -1))

  for (( i=0; i<$n; i++ ))
  do
    COMB[$i]=${scenario_ids[$i]}
    if [[ $i == 0 ]]
    then
        echo ${COMB[$i]}","
    elif [[ $i == $last ]]
    then
            echo  ${COMB[$i]}
    else
            echo  ${COMB[$i]}","
    fi
  done >> ids_scenarios.json

  if [[ $? -eq 0 && $response =~ ^2 ]]; then

    ids_scenarios=$(cat ./ids_scenarios.json)

    test_run_id=$( curl -sS https://app.hiptest.com/api/projects/$PROJECT_ID/test_runs \
            -H "accept: application/vnd.api+json; version=1" \
            -H "access-token: $API_ACCESS_TOKEN" \
            -H "uid: $API_UID" \
            -H "client: $API_CLIENT" \
            --data '{"data": {"attributes": {"name": "My new test run based on '"$TAG_KEY"' tag", "description": "This test run has been created from a GitHub workflow", "scenario_ids": ['"$ids_scenarios"'] } } }' \
            | jq -r '.data["id"]' )

    # echo "::set-output name=TEST_RUN_ID::$test_run_id"

    echo $test_run_id >> ./test_run_id.json

    sleep 1

    # echo "Your test run ID: $test_run_id has been successfully created"

  else
    echo "ERROR: Failed to create a new test run based on $TAG_KEY tag in project ID: $PROJECT_ID, response code received was $response"
  fi
else
  echo "ERROR: Failed to retrieve scenarios with $TAG_KEY tag from project ID: $PROJECT_ID, response code received was $response"
fi
