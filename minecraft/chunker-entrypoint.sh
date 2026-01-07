#! /bin/sh

set -x

CHUNKER_JARFILE=${CHUNKER_JARFILE:?Need to know where chunker jarfile is}
BLUEMAP_JARFILE=${BLUEMAP_JARFILE:?Need to konw where the bluemap jarfile is}
BACKUP_FOLDER=${BACKUP_FOLDER:?Need to know where backups folder is}
WORLD_FOLDER=${WORLD_FOLDER:?Need to know where export folder is}

# purge the old world folder. I ran into a bunch of consistency issues so this
# is probably unnecessary
rm -rf ${WORLD_FOLDER}
mkdir ${WORLD_FOLDER}


OUTPUT_FORMAT=JAVA_1_21

# find the most recent backup in the backups folder
# MOST_RECENT_FILE=$(ls -t $BACKUP_FOLDER/*.mcworld | head -n1)
MOST_RECENT_FILE=$(find $BACKUP_FOLDER -type f -name '*.mcworld' -printf '%T@ %p\0' | sort -zrn | sed -Ezn '1s/[^ ]* //p')

# extract the most recent backup into a temp folder
EXTRACT_FOLDER=$(mktemp -d)
7z x -o${EXTRACT_FOLDER} "${MOST_RECENT_FILE}"

# run chunker on it to convert to a java style minecraft world and dump it into
# the world folder
java -jar ${CHUNKER_JARFILE} \
  --inputDirectory ${EXTRACT_FOLDER} \
  --outputDirectory ${WORLD_FOLDER} \
  --outputFormat ${OUTPUT_FORMAT}

# generate the map files
java -jar ${BLUEMAP_JARFILE} --render --force-render

# and then serve them
java -jar ${BLUEMAP_JARFILE} --webserver
  