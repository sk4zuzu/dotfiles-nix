#!/usr/bin/env bash
id; (( UID )) && exec doas bash "$0"; set -e

install -d /stor/target/

rm -f /stor/target/36G.img

targetcli <<'EOF'
cd /
clearconfig confirm=true
set global auto_add_default_portal=false

/backstores/fileio create name=36G file_or_dev=/stor/target/36G.img size=36G

/iscsi create iqn.1970-01.lh.repti:target.asd
/iscsi/iqn.1970-01.lh.repti:target.asd/tpg1/luns/ create /backstores/fileio/36G
/iscsi/iqn.1970-01.lh.repti:target.asd/tpg1/acls/ create iqn.1970-01.lh.repti:client.asd
/iscsi/iqn.1970-01.lh.repti:target.asd/tpg1/portals/ create 0.0.0.0 3260

/iscsi create iqn.1970-01.lh.repti:target.ead
/iscsi/iqn.1970-01.lh.repti:target.ead/tpg1/luns/ create /backstores/fileio/36G
/iscsi/iqn.1970-01.lh.repti:target.ead/tpg1/acls/ create iqn.1970-01.lh.repti:client.ead
/iscsi/iqn.1970-01.lh.repti:target.ead/tpg1/portals/ create 0.0.0.0 3261
EOF
