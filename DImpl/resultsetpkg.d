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
