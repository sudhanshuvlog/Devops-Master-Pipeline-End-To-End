socat TCP4-LISTEN:8080,fork,su=nobody TCP4:$(hostname -I | awk '{print $3}'):31933 &
