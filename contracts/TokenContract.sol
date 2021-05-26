pragma solidity ^ 0.4.24;

contract math{
    
    function Addition(uint a , uint b) public pure returns(uint c)
    {
        c = a +b ;
        require(c >= a);
    }
    
    function Subtraction(uint a , uint b) public pure returns(uint c)
    {
        require(b <= a);
        c = a-b;
    }

    function Multiplication(uint a , uint b) public pure returns(uint c)
    {
        c = a *b ;
        require(a == 0 || c / a == b);
    }
    
    function Division(uint a, uint b) public pure returns(uint c)
    {
        require(b>0);
        c = a/b;
    }
}



contract ERC20Interface {
    function totalSupply() public constant returns(uint);
    function balanceOf(address tokenOwner) public constant returns(uint balance);
    function allowance(address tokenOwner , address spender) public constant returns(uint remaining);
    function transfer(address to, uint tokens) public returns(bool success);
    function approve(address spender, uint tokens) public returns(bool success);
    function transferFrom(address from, address to, uint tokens) public returns(bool success);

    event Transfer(address indexed from, address indexed to , uint tokens);
    event Approval(address indexed tokenOwner , address indexed spender , uint tokens);
}

contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}


contract TokenName is ERC20Interface,math{
    string public symbol ;
    string public name ;
    uint public decimals;
    uint public _totalSupply;
    
    mapping(address => uint) balances;
    mapping(address=>mapping(address=>uint))allowed;
    
    
    constructor() public
    {
        symbol="YOUR TOKEN SYMBOL";
        name="YOUR TOKEN NAME";
        decimals=18;
        _totalSupply = 100000000;
        balances[0x3aa821cEE6194C4aD7e3F3d6E393F646D1Cd65Db] = _totalSupply;
        emit Transfer(address(0) , 0x3aa821cEE6194C4aD7e3F3d6E393F646D1Cd65Db , _totalSupply);
    }
    
    function() public payable
    {
        revert();
    }
    
    function totalSupply() public constant returns(uint )
    {
        return _totalSupply - balances[address(0)];
    }

    function balanceOf(address tokenOwner) public constant returns(uint balance)
    {
        return balances[tokenOwner];
    }
    
    function transfer(address to , uint tokens ) public returns(bool success)
    {
        balances[msg.sender] = Subtraction(balances[msg.sender] , tokens);
        balances[to] = Addition(balances[to] , tokens);
        emit Transfer(msg.sender , to , tokens);
        return true;
    }

    function allowance(address tokenOwner ,address spender )public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
    
    function transferFrom(address from , address to , uint tokens)public returns(bool success)
    {
        balances[from] = Subtraction(balances[from], tokens);
        allowed[from][msg.sender] = Subtraction(allowed[from][msg.sender], tokens);
        balances[to] = Addition(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }
    
     function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    
     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
     }
    
}