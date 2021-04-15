pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Return_R0R is ERC20 {
    
    uint256 initialSupply = 1000;
    uint256 Reward = 10;
    address owner;
    
    struct Worker {
        address addr;
        uint256 number;
        string name;
        bool valid;
    }
    
    mapping(address => Worker) public worker;    
    
    modifier onlyWorker() {
        
        require(worker[msg.sender].valid == true, "Only workers can call this function");
        _;
        
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    constructor() ERC20("Return_Tokens", "ROR") {
        owner = msg.sender;
        _mint(msg.sender, initialSupply);
        
    }
    
    function makeWorker(address _worker, uint256 _number, string memory _name) public onlyOwner {
        
        worker[_worker] = Worker(_worker, _number, _name, true);
        
    }
    
    function mintReward() public onlyWorker {
        _mint(msg.sender, Reward);
        
    }
    
}
