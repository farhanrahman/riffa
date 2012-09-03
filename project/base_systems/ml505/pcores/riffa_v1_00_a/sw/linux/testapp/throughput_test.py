import os

if __name__=="__main__":
	if os.path.isfile("riffaexample"):
		startRunTime = 512
		endRunTime = 8388608
		outputCycle = 2
		stride = 2048
		try:
			while(1): 
				dataFile = open("data.txt","w")
				dataFile.write("%d\n"%startRunTime)
				dataFile.write("%d\n"%outputCycle)
				dataFile.close()
				for i in range(0,100):
					out = os.system("./riffaexample")
				if startRunTime == endRunTime:
					break
				startRunTime += stride
		except IOError as e:
			print ("Problem in opening file: %s"%e)	
	else:
		print "file does not exist"	 
