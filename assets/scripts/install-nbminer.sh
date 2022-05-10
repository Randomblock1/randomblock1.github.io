#!/bin/bash
cat <<EOF

██╗     ██╗  ██╗██████╗     ██████╗ ██╗   ██╗██████╗  █████╗ ███████╗███████╗
██║     ██║  ██║██╔══██╗    ██╔══██╗╚██╗ ██╔╝██╔══██╗██╔══██╗██╔════╝██╔════╝
██║     ███████║██████╔╝    ██████╔╝ ╚████╔╝ ██████╔╝███████║███████╗███████╗
██║     ██╔══██║██╔══██╗    ██╔══██╗  ╚██╔╝  ██╔═══╝ ██╔══██║╚════██║╚════██║
███████╗██║  ██║██║  ██║    ██████╔╝   ██║   ██║     ██║  ██║███████║███████║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝    ╚═════╝    ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝
https://randomblock1.com/blog/lhr-full-unlock

EOF
TMPDIR=$(mktemp -d)
cd "$TMPDIR" || echo "Unable to create temp directory, is mktemp installed?" && exit 1
wget https://cdn.discordapp.com/attachments/973589122298048603/973591469510246540/NBMiner_41.4_Linux.tgz
tar -xvf NBMiner_41.4_Linux.tgz
miner stop
cp NBMiner_Linux/nbminer /hive/miners/nbminer/41.3
miner start
echo "Success! NBMiner 41.3 has been replaced with NBMiner 41.4 (LHR v1/2 Bypass + v3 90%)."
