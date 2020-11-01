rack_no = ARGV[0]
srv_no  = ARGV[1]

loopback_ip = sprintf("192.168.#{rack_no}0.#{srv_no}")

neighbor_id = sprintf("652%02d", rack_no.to_i-1)
client_id   = sprintf("653%02d", srv_no.to_i)

neighbor_ip = sprintf("169.254.0.%d", (srv_no.to_i-1)*4+1)
client_ip   = sprintf("169.254.0.%d", (srv_no.to_i-1)*4+2)

puts <<-EOL

enable
configure terminal
hostname Client#{rack_no}-#{srv_no}
interface Loopback0
 ip address #{loopback_ip} 255.255.255.255
interface GigabitEthernet0
 ip address #{client_ip} 255.255.255.252
no router bgp #{client_id}
router bgp #{client_id}
 bgp log-neighbor-changes
 no synchronization
 timers bgp 3 9
 neighbor #{neighbor_ip} remote-as #{neighbor_id}
 network #{loopback_ip} mask 255.255.255.255
end

EOL
