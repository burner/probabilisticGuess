# Copyright (C) 2010 - Robert Schadek
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
# 

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
			retL.append(t)
		x+=1
	#addup(retL)	
	return retL

def randBoolRange(range):
	t = random.random()
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
