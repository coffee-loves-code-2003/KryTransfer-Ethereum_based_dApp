// SPDX-License-Identifier: MIT
contract ExpenseManagerContract
{
    address public owner;
    //transaction model
    struct Transaction
    {
        address user;
        uint amount;
        string reason;
        uint time;
    }
    Transaction[] public transactions;
    
    constructor(){
        owner = msg.sender;
    }
     modifier onlyOwner(){
        require(msg.sender == owner,"Only Autherized user can execute");
        _;
    }
    mapping(address => uint) public balances;
    event Deposit(address indexed from,uint amount,string reason,uint timestamp);
    event Withdraw(address indexed to,uint amount,string reason,uint timestamp);

    function deposit_crypto(uint amount,string memory reason) public payable{
        require(amount > 0, "Enter deposit amount greater than zero");
        balances[msg.sender] += msg.value;
        transactions.push(Transaction(msg.sender,amount,reason,block.timestamp));
        emit Deposit(msg.sender, amount, reason, block.timestamp);
    }

    function withdraw_crypto(uint amount,string memory reason)public{
        require(balances[msg.sender]>= amount,"Insufficent balance");
        balances[msg.sender] -= amount;
        transactions.push(Transaction(msg.sender,amount,reason,block.timestamp));
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount, reason, block.timestamp);
    }

    function balance_amount(address account)public view returns(uint){
        return balances[account];
    }

    function getTransactionCount()public view returns(uint){
        return transactions.length;

    }
    function getParticularTransaction(uint index)public view returns(address,uint,string memory,uint )
    {
        require(index < transactions.length,"Index out of range");
        Transaction memory transaction = transactions[index];
        return (transaction.user,transaction.amount,transaction.reason,transaction.time);
    }
    function getAllTransaction()public view returns(address[] memory,uint[] memory,string[] memory,uint[] memory){
        address[] memory users = new address[](transactions.length);
        uint[] memory amounts = new uint[](transactions.length);
        string[] memory reasons = new string[](transactions.length);
        uint[] memory timestamps = new uint[](transactions.length);

        for(uint i = 0;i < transactions.length;i++)
        {
            users[i] = transactions[i].user;
            amounts[i] = transactions[i].amount;
            reasons[i] = transactions[i].reason;
            timestamps[i] = transactions[i].time;
        }
        return(users,amounts,reasons,timestamps);

    }
    function changeOwner(address newowner)public onlyOwner{
        owner = newowner;
    }

function transfer_crypto(address payable recipient, string memory reason) public payable {
    require(msg.value > 0, "Send Ether greater than zero");
    require(recipient != address(0), "Invalid recipient address");

    recipient.transfer(msg.value);

    transactions.push(Transaction(recipient, msg.value, reason, block.timestamp));

    emit Deposit(msg.sender, msg.value, reason, block.timestamp);
}






   
}