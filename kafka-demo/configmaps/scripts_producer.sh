#!/usr/bin/env bash

while true; do
   date | tee | kafka-console-producer.sh --topic test --broker-list kafka-broker-0.kafka-broker:9092
   sleep 1
done

