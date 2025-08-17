#!/bin/bash

set -e

PACKAGE_ID="0x14ef32161bfde1e0964434c53346eba5dfbeab6f07a0c3b800151a0a2c15c92b"
TIMESTAMP=$(date +%s)
ADDR1="0x21238d61f321e5a18c0872ac3af5055794e1dab097c8b467d201a7bd3eab31e2"
ADDR2="0xcb4e7b6963bc04b18a284edb5c4d4029a72d535674a798ac363c13ed46eeafd1"

echo ">>> 1. Calling hello()"
sui client call --package $PACKAGE_ID --module encounter_log --function hello --gas-budget 10000000

echo ">>> 2. Logging single encounter"
sui client call --package $PACKAGE_ID --module encounter_log --function log_encounter \
  --args $ADDR1 $TIMESTAMP --gas-budget 10000000

echo ">>> 3. Logging batch encounters"
sui client call --package $PACKAGE_ID --module encounter_log --function log_encounters \
  --args "[$ADDR1,$ADDR2]" $TIMESTAMP --gas-budget 10000000

echo ">>> 4. Listing objects..."
sui client objects | grep encounter_log::Encounter

ENCOUNTER_ID=$(sui client objects --json | jq -r '.[] | select(.data.type | contains("encounter_log::Encounter")) | .data.objectId' | head -n 1)

echo ">>> 5. Calling get_info on $ENCOUNTER_ID"
sui client call --package $PACKAGE_ID --module encounter_log --function get_info \
  --args $ENCOUNTER_ID --gas-budget 10000000

echo ">>> 6. Burning Encounter $ENCOUNTER_ID"
sui client call --package $PACKAGE_ID --module encounter_log --function burn_expired_encounter \
  --args $ENCOUNTER_ID --gas-budget 10000000

echo ">>> 7. Final object list (should be 1 less)"
sui client objects | grep encounter_log::Encounter
