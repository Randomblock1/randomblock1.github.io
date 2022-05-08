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
wget https://github.com/NebuTech/NBMiner/releases/download/v41.0/NBMiner_41.0_Linux.tgz
tar -xvf NBMiner_41.0_Linux.tgz
miner stop
cp NBMiner_Linux/nbminer /hive/miners/nbminer/40.1
miner start
echo "Success! NBMiner 40.1 has been replaced with NBMiner 41 (LHR Bypass)."
