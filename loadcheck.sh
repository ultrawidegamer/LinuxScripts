#-------------------------------------------------------------------------------
#                              GLOBAL VARIABLES
#-------------------------------------------------------------------------------
cpuMemGbMin=20 # minimum amount of cpu memory required
cpuPercentMin=30 # minimum amount of cpu % required

gpuMemGbMin=4 # minimum amount of gpu memory required
gpuPercentMin=50 # minimum amount of gpu % required

#-------------------------------------------------------------------------------
#                            LOAD DATA COLLECTION
#-------------------------------------------------------------------------------
if command -v vmstat >/dev/null 2>&1; then
    cpu=$(vmstat 1 2 | tail -1 | awk '{printf "%d\n", 100-$15}')
fi

if command -v free >/dev/null 2>&1; then
    cpumem=$(free | awk '/^Mem:/{printf "%d\n", $7/1048576}')
fi

if command -v nvidia-smi >/dev/null 2>&1; then
    gpumem=$(nvidia-smi --query-gpu=memory.free --format=csv,noheader,nounits | awk '{printf "%d\n", $1/1024}')
    gpu=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
fi

#-------------------------------------------------------------------------------
#                              THRESHOLD CHECKS
#-------------------------------------------------------------------------------
maxCpu=$((100 - cpuPercentMin))
maxGpu=$((100 - gpuPercentMin))

if ((cpu > maxCpu)); then
  printf 'error: cpu (%s) exceeds threshold (%s)\n' "$cpu%" "$maxCpu%" >&2
  exit 1
fi

if ((cpumem < cpuMemGbMin )); then
  printf 'error: cpu memory (%s) is less than threshold (%s)\n' "$cpumem GB" "$cpuMemGbMin GB" >&2
  exit 1
fi

if ((gpu > maxGpu)); then
  printf 'error: gpu (%s) exceeds threshold (%s)\n' "$gpu%" "$maxGpu%" >&2
  exit 1
fi

if ((gpumem < gpuMemGbMin )); then
  printf 'error: gpu memory (%s) is less than threshold (%s)\n' "$gpumem GB" "$gpuMemGbMin GB" >&2
  exit 1
fi
