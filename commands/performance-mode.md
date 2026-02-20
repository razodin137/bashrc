```bash
# To set "performance-mode" as a command in ~/.bashrc
# Simply paste the command starting with 'echo' to run it in the terminal.

alias performance-mode='echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'
```
