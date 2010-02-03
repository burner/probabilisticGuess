module resultsetpkg;

class ResultSet {
	bool readWrite; //false write, true read
	uint accessCount; //how many peers needed to be accessed
	bool accessSuccess; //if the operation where a succes
	bool readOperationSuccess; //if the right value was read
	uint guessed, searched; //the guessed value, the value that was searched
}
