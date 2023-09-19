
print("Hello!")
let udpclient=UDPClient(address: "169.254.249.60",port:56001);

    
while(true){
    udpclient?.recv();
}
