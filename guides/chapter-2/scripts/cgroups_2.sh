CGROUP_DIR="/sys/fs/cgroup/memory/extraordy2"
echo "Creating a cgroups directory named extraordy if not exists"
if [ ! -d "$CGROUP_DIR" ]; then mkdir $CGROUP_DIR; fi


echo "Limit the memory usage to 500 bytes"
echo "500" > "$CGROUP_DIR/memory.limit_in_bytes"

echo "Running a background sample process"
./simple_process.sh & 
PID=$!

echo "simple_process.sh PID = $PID"
echo "Assig the PID $PID to extraordy's memory cgroup"
echo $PID > "$CGROUP_DIR/cgroup.procs"

sleep 1

echo "Press enter key to view $PID memory usage and limit in bytes"
read i
USAGE=$(cat "$CGROUP_DIR/memory.usage_in_bytes")
LIMIT=$(cat "$CGROUP_DIR/memory.limit_in_bytes")
echo "Memory usage of pid $PID is $USAGE bytes, memory limit is $LIMIT. Something went wrong..."
echo "Press enter key to see the journal log"
read i
journalctl -ex | egrep $PID 




