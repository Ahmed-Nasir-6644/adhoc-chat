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
        "SSID": "ISE-19",
        "Channel_Freq": "2437",
        "Channel_Num": "6",
        # not used - for the cases require overwriting MAC address
        "MAC_Address": "74:da:38:68:73:5f"
    }
    
]
