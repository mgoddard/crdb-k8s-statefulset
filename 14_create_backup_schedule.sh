#!/bin/bash

cat <<EndOfMsg

For this, you will need an Enterprise license.

Once that is applied to your cluster, you will need to:

* Create a Cloud Storage bucket into which your backups will be written
* Create a service account and download a key for that account in JSON format
* Base 64 encode that key; e.g. (on a Mac): base64 < your_key.json
* Edit the schedule_backups.sql file with your bucket and the Base 64 encoded key

With that in place, you're ready to proceed.

EndOfMsg

read -p "Type 'Y', ENTER continue: " y_n
y_n=${y_n:-N}
case $y_n in
  ([yY])
    ;;
  (*)
    echo "Aborting"
    exit 0
    ;;
esac

echo "Creating the backup schedule ..."
cat schedule_backups.sql | kubectl exec -it cockroachdb-client-secure -- ./cockroach sql --certs-dir=/cockroach-certs --host=cockroachdb-public
echo "Done.  You can see this schedule in the DB Console, under 'Schedules'."

