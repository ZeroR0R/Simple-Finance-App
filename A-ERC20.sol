pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./vips.sol";

contract Return_R0R is ERC20, VIPs {
    
    uint256 initialSupply = 1000;
    uint256 Reward = 1;
    uint256 MidReward = 20;
    address owner;
    
    struct Worker {
        address addr;
        string name;
        uint256 mints;
        bool valid;
    }
    
    mapping(address => Worker) public worker;    
    
    modifier onlyWorker() {
        
        require(worker[msg.sender].valid == true, "Only workers can call this function");
        _;
        
    }
    
    modifier onlyVIP() {
        
        require(isVIP[msg.sender] == true, "Only VIPs can call this function");
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
    
    function hireWorker(address _worker, string memory _name) public onlyVIP {
        
        worker[_worker] = Worker(_worker, _name, 0, true);
        
    }
    
    function mintReward() public onlyWorker {
        require(worker[msg.sender].mints <= 5, "You have already minted the maximum amount of times");
        _mint(msg.sender, Reward);
        worker[msg.sender].mints = worker[msg.sender].mints + 1;
        
    }
    
    function mintMediumReward() public onlyVIP {
        
        require(hasMintedMid[msg.sender] == false, "You have already minted a reward.");
        require(WorkersHired[msg.sender] > 4, "You need to hire five more workers in order to mint a large reward");
        _mint(msg.sender, MidReward);
        hasMintedMid[msg.sender] = true;
        
    }
    
    function buyVIPLicense() public onlyWorker {
        
        require(isVIP[msg.sender] == false, "You have already bought this!");
        require(balanceOf(msg.sender) >= VIP_License_Price);
        transfer(owner, VIP_License_Price);
        isVIP[msg.sender] = true;
        WorkersHired[msg.sender] = 0;
        hasMintedMid[msg.sender] = false;
        
    }
    
    function setVIP(address _user) public onlyOwner {
        
        require(isVIP[_user] == false, "This user already has this item");
        isVIP[_user] = true;
        WorkersHired[_user] = 0;
        hasMintedMid[_user] = false;
    }
    
}
