#! /bin/sh
qingStorEnable=testqingstore

# only download war when qingStor is enabled
if [ -n "$qingStorEnable" ]
then
	qsctl cp -f qs://testqingstore/webDemo03.war /tmp/war-listen/
fi
