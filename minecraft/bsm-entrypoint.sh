#!/bin/bash

# start cron for bsm to use
service cron start

# start bsm (copied from upstream dockerfile CMD)
bedrock-server-manager web start --host $HOST --port $PORT