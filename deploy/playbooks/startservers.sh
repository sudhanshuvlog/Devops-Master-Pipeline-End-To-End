ssh -i mykey ec2-user@$(awk '/\[prod\]/{getline; print $1}' inventory) 'sudo socat TCP4-LISTEN:8080,fork,su=nobody TCP4:192.168.49.2:31933' &
