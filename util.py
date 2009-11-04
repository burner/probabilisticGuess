import random

def randintuni(list, min, max):
	l = False
	while True:
		l = False
		tmp = random.randint(min, max)
		for x in list:
			if x == tmp:
				l = True
				break
		if l:
			continue
		
		return tmp

def randMakeOne(len):
	sum = 0.0
	retL = []
	x = 0
	while x < len:
		if x == len-1:
			retL.append(1.0-sum)
		else:
			t = random.random()*(1.0-sum)
			sum+=t
			#print t
			retL.append(t)
		x+=1
	#addup(retL)	
	return retL

def randBoolRange(range):
	t = random.randon()
	if t >= (1-range):
		return True
	else:
		return False

def addup(list):
	t = 0.0
	i = 0
	while i < len(list):
		t+= list[i]
		i+=1

	print t
