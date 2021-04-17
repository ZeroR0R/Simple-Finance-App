pragma solidity ^0.8.0;

import "./erc20sep.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Lending is Return_R0R {

    using SafeMath for uint256;
    
    uint interestRate = 1;
    
    struct Loan {
        uint256 amount;
        uint256 collateral;
        bool repaid;
    }
    
    mapping(address => uint256) internal collateral;
    mapping(address => Loan) public loan;
    
    event CollateralDeposited(address _user, uint _amount);
    event CollateralRepaid(address _user, uint _amount);
    
    event LoanCreated(address _user, uint _amount);
    event LoanRepaid(address _user);
    
    mapping(address => bool) public HasActiveLoan;
    
    function depositCollateral(address _user, uint256 _amount) internal {
        collateral[_user] = _amount; 
        _transfer(_user, owner, collateral[_user]);
        
        emit CollateralDeposited(_user, _amount);
    }
    
    function repayCollateral(address _user) internal {
        _transfer(owner, _user, collateral[_user]);
        emit CollateralRepaid(_user, collateral[_user]); 
        
    }
    
    function takeLoan(uint256 _amount) public {
        
        address user = msg.sender;
        
        require(HasActiveLoan[msg.sender] != true, "You already have a loan active, repay that first");    
        require(balanceOf(msg.sender) > _amount, "You need more tokens in order to take out this loan.");
        uint256 loanAmount = _amount.mul(5);
        require(loanAmount < balanceOf(owner), "Loan is too large.");
        depositCollateral(user, _amount);
        _transfer(owner, msg.sender, loanAmount);
        loan[msg.sender] = Loan(loanAmount, _amount, false);
        HasActiveLoan[msg.sender] = true;
        
        emit LoanCreated(user, _amount);
        
    }
    
    function repayLoan() public {
        require(HasActiveLoan[msg.sender] == true, "You don't have a loan to repay");
        require(balanceOf(msg.sender) > loan[msg.sender].amount, "You need more tokens in order to repay this loan");
        _transfer(msg.sender, owner, loan[msg.sender].amount);
        repayCollateral(msg.sender);
        HasActiveLoan[msg.sender] = false;
        
        emit LoanRepaid(msg.sender);
        
    }
    
    function repayLoanBehalf(address _loaner) public {
        
        require(HasActiveLoan[_loaner] == true, "This user does not have an active loan.");
        require(balanceOf(msg.sender) > loan[_loaner].amount, "You need more tokens in order to repay this loan");
        _transfer(msg.sender, owner, loan[_loaner].amount);
        loan[_loaner].repaid = true;
        HasActiveLoan[_loaner] = false;
        repayCollateral(_loaner);
        
        emit LoanRepaid(_loaner);
        
    }
    
}
