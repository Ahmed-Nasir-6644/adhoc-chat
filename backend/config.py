## Configuration parameters for the device
#

""" Fill out the following """
node = "name_of_network_node"

interfaces = [
    {
        "device_name": "wlp2s0",
        "type": "BATMAN",
        "IP": "10.10.1.1",
        "Cell_ID": "02:12:34:56:78:9D",
        "SSID": "CTLnetwork",
        "Channel_Freq": "2412",
        "Channel_Num": "1",
        # not used - for the cases require overwriting MAC address
        "MAC_Address": "74:da:38:68:73:5f"
    }
    
]
