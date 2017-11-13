#!/bin/bash
set -e

# REQUIREMENTS:
#  - PostgreSQL installed locally
#  - Database `csvkit` created
#  - User can run `psql` and has access to csvkit database
#  - Virtualenv named `csvkit` with csvkit installed

if [ ! $# -eq 1 ]; then
    echo "usage: $0 <csv file>"
    exit 1
fi

if [ ! -r "$1" ]; then
    echo "error: failed to open $1"
    exit 1
fi

CSV_FILE=$1
PSQL="psql -v ON_ERROR_STOP=1 csvkit"

# DETERMINE TABLE NAME

TABLE_NAME=$(
  basename "$CSV_FILE" .csv | \
  tr "A-Z" "a-z" | \
  sed "s/[^A-Za-z0-9]/_/g"
)

# DROP OLD TABLE

echo "DROP TABLE IF EXISTS $TABLE_NAME;" | $PSQL

# (RE)CREATE TABLE

TABLE_CREATE=$(
  source ~/.virtualenvs/csvkit/bin/activate
  head -n 99 "$CSV_FILE" | \
  csvsql -i postgresql --tables $TABLE_NAME
)

echo "$TABLE_CREATE" | \
sed "s/VARCHAR([0-9]*)/VARCHAR(1024)/" | \
psql csvkit

# IMPORT DATA

echo "COPY"
cat "$CSV_FILE" | psql -c "COPY $TABLE_NAME FROM STDIN WITH CSV HEADER" csvkit

# INVOKE PSQL SHELL

psql csvkit

