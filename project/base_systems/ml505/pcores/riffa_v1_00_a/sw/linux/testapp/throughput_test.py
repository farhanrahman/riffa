import os

if __name__=="__main__":
	if os.path.isfile("riffaexample"):
		word = 60
		endRunTime = 16384
		try:
			while(word <= endRunTime): 
				dataFile = open("data.txt","w")
				dataFile.write("%d\n"%word)
				dataFile.close()
				for i in range(0,100):
					out = os.system("./riffaexample")
				word += 1
		except IOError as e:
			print ("Problem in opening file: %s"%e)	
	else:
		print "file does not exist"	 
