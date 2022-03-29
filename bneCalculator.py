import copy

def subHex(hexDestination,hexSource):
    sub = int(hexDestination,16) - int(hexSource,16)
    return sub

def DemicalToBinary(num):
    binaryNum = bin(num).replace("0b", "")[:-1]
    while True:
        if len(binaryNum) != 12:
            binaryNum = "0" + binaryNum
        else:
            b = copy.deepcopy(binaryNum)
            binaryNum = b[0] +b[2:8] + b[8:12] + b[1]
            return binaryNum

def binaryToHexConv(binaryNum):
    hexCom = hex(int(binaryNum,2))[2:]
    return hexCom

def fillComTo8(command):
    return command.zfill(8)

def bneConverter(hexDestination,hexSource,Rs1,Rs2):
    subNum = subHex(hexDestination,hexSource)
    jump = DemicalToBinary(subNum)
    funct3 = "001"
    opcode = "1100011"
    BinCommand = jump[0:7] + Rs2 + Rs1 + funct3 + jump[7:12] +opcode
    command = binaryToHexConv(BinCommand)
    hexCommand = fillComTo8(command)
    return hexCommand

if __name__=='__main__':
    hexDestination = "c8"
    hexSource = "a8"
    registerRs1 = "11100" #t3
    registerRs2 = "11101" #t4
    #registerRs1 = "00011" #gp
    #registerRs2 = "00000" #zero
    command = bneConverter(hexDestination,hexSource,registerRs1,registerRs2)
    print(command)


            

