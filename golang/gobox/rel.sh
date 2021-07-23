#
# 10 * * * * /g2/gcbox/gcbox wiscon --host http://localhost:9200 --alljobs --backs=2 >> /var/gdca/journal/wiscon.log 2>>/var/gdca/journal/wiscon.log
#

go build
scp gcbox BigEDA@bigsftp:/home/BigEDA/gdca/g2/gcbox

