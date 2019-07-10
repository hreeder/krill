
function sanitize_cgroups() {
  mkdir -p /sys/fs/cgroup
  mountpoint -q /sys/fs/cgroup || \
    mount -t tmpfs -o uid=0,gid=0,mode=0755 cgroup /sys/fs/cgroup

  mount -o remount,rw none /sys/fs/cgroup

  sed -e 1d /proc/cgroups | while read sys hierarchy num enabled; do
    if [ "$enabled" != "1" ]; then
      # subsystem disabled; skip
      continue
    fi

    grouping="$(cat /proc/self/cgroup | cut -d: -f2 | grep "\\<$sys\\>")" || true
    if [ -z "$grouping" ]; then
      # subsystem not mounted anywhere; mount it on its own
      grouping="$sys"
    fi

    mountpoint="/sys/fs/cgroup/$grouping"

    mkdir -p "$mountpoint"

    # clear out existing mount to make sure new one is read-write
    if mountpoint -q "$mountpoint"; then
      umount "$mountpoint"
    fi

    mount -n -t cgroup -o "$grouping" cgroup "$mountpoint"

    if [ "$grouping" != "$sys" ]; then
      if [ -L "/sys/fs/cgroup/$sys" ]; then
        rm "/sys/fs/cgroup/$sys"
      fi

      ln -s "$mountpoint" "/sys/fs/cgroup/$sys"
    fi
  done

  if ! test -e /sys/fs/cgroup/systemd ; then
    mkdir /sys/fs/cgroup/systemd
    mount -t cgroup -o none,name=systemd none /sys/fs/cgroup/systemd
  fi
}

sanitize_cgroups

stty columns 80

ran_progress="false"

function progress() {
  if [ "$ran_progress" = "true" ]; then
    echo ""
  fi

  ran_progress="true"

  echo $'\e[1m'"$@"$'\e[0m'
}

apk add docker

docker daemon &
running_container=$(docker run --rm -tid hreeder/krill:testing)

ls