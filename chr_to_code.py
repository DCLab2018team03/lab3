s = input("Words: ")
addr = input("begin address: ")

def c_to_int(c):
    num = ord(c)
    return hex(num)

addr = int(addr)
print()
for c in s:
    print("8'h{}: begin".format(hex(addr)[2:].rjust(2, '0')))
    print("    ADDRESS <= 8'h{};".format(hex(addr)[2:].rjust(2, '0')))
    print("    CHARACTER <= 8'h{}; // {}".format(hex(ord(c))[2:].rjust(2, '0'), c))
    print("    address <= 8'h{};".format(hex(addr+1)[2:].rjust(2,'0')))
    print("end")
    addr += 1
print()
