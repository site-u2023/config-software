cat <<"EOF" >> /usr/bin/dfslog
#!/bin/sh
sh /etc/config-software/dfs-config.sh
echo -----------------------------------------------
echo DFS Check NOW log:
exec logread | grep "DFS Check NEW" | awk '{ print $1,$2,$3,$4,$5,$8,$9,$10,$11 }'
echo DFS operating status:
exec logread | grep "DFS->DISABLED" | tail -n 1 | awk '{ print $1,$2,$3,$4,$5,$11 }'
exec logread | grep "DFS->ENABLED"  | tail -n 1 | awk '{ print $1,$2,$3,$4,$5,$11 }'
echo -----------------------------------------------
EOF
chmod +x /usr/bin/dfslog
