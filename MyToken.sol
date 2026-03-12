contract MyToken {
    mapping (address => uint) public balanceof;
    event Transfer(address _from, address _to, uint256 _value);
    function MyToken(uint supply) {
        if (supply == 0) supply = 10000;
        balanceof[msg.sender] = supply;
    }
    function transfer(address _to, uint256 _value) returns (bool success) {
        if (balanceof[msg.sender] < _value) return false;
        balanceof[msg.sender] -= _value;
        balanceof[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balanceof[_owner];
    }
}
