import os

if __name__=="__main__":
	if os.path.isfile("riffaexample"):
		runTime = 512
		endRunTime = 32768
		outputCycle = 2
		try:
			while(runTime != endRunTime + 4): 
				dataFile = open("data.txt","w")
				dataFile.write("%d\n"%runTime)
				dataFile.write("%d\n"%outputCycle)
				dataFile.close()
				for i in range(0,100):
					out = os.system("./riffaexample")
				runTime += 4
			for i in range(0,100):
				out = os.system("./riffaexample")
		except IOError as e:
			print ("Problem in opening file: %s"%e)	
	else:
		print "file does not exist"	 
