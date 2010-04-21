/* Copyright (C) 2010 - Robert Schadek
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public License
* as published by the Free Software Foundation; either version 2
* of the License, or (at your option) any later version.
* 
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
* 
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
* 
*/

module resultsetpkg;

class ResultSet {
	public bool readWrite; //false write, true read
	public uint accessCount; //how many peers needed to be accessed
	public bool accessSuccess; //if the operation where a succes
	public bool readOperationSuccess; //if the right value was read
	public uint guessed, searched; //the guessed value, the value that was searched
	this(bool readWrite, uint accessCount, bool accessSuccess,
		 bool readOperationSuccess, uint guessed, uint searched) {
			this.readWrite = readWrite;
			this.accessCount = accessCount;
			this.accessSuccess = accessSuccess;
			this.readOperationSuccess = readOperationSuccess;
			this.guessed = guessed;
			this.searched = searched;
	}
}
