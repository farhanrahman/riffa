import os
if __name__=="__main__":
	count = 0
	for i in range(0,100):
		output = os.system("./riffaexample > log.txt")
		if output != 0:
			count = count+1
			fin = open('log.txt','r')
			print(fin.read())
			fin.close()
		os.system("rm log.txt");
	print "total number of errors: %d"%count	
