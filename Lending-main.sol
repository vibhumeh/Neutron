// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../ERC20/ERC20.sol";
import "./vouching.sol";
contract Loaning is vouching(address(this)), Neutron(msg.sender,address(this)) {
using SafeMath for uint256;

//Neutron token=new Neutron(msg.sender,address(this));
uint adj=10**18; //decimal adjustment
address reciever; //the address of this contract
address allowedcon;
address allowedcon2;
address governor;
address _owner;
address treasury;
IERC20 token;
BMIERC20 _token;
uint lim;
constructor(uint _lim,address _treasury){
token=IERC20(address(this));
_token=BMIERC20(address(this));
lim=_lim; //upper limit of tiers
_owner=msg.sender;
treasury=_treasury;

}
//
modifier only_owner(){
    require(msg.sender==_owner);
_;}
/*function set(address tk)public{
    token=IERC20(tk);
    _token=BMIERC20(tk);
}*/
mapping (address => bool) private _match; //checks if the loan taker has taken the highest teir loan availible to them
mapping (address =>uint) private timer; // stores the time when loanee returned last loan
mapping (address=>uint) public cooldown; //amount of time between two loans
mapping (address=> uint) public creditsc_c; // capped credit score, stops @20
mapping (address=>uint) public defults;
mapping (address=>uint) public repayed;
mapping (address =>uint) rounds; //stores number of times the loanee has taken the highest loan possible
mapping (address =>uint) roundsreq; // the number of times the person must return a loan of a particular tier to level up (rounds resets to 0 every time target is reached)
mapping (address=>uint) public creditsc_uc; // uncapped credit score, can go beyond 20, 
mapping (address =>bool) public pending; //if loan not returned yet, true.
mapping (address => uint) amount; //amount loaned
mapping (address => uint) meddefprinc;
mapping (address=> uint ) public principal;//money required to be repayed.
mapping (address => uint) time;

//function to take loan
function takeloan (uint tier) public payable{
require(block.timestamp.sub(timer[msg.sender])>=cooldown[msg.sender],"you are still under cooldown"); //so no loan spams
require(creditsc_c[msg.sender]>=tier,"you do not have a high enough credit score");
require(tier>0);
require(pending[msg.sender]==false);

amount[msg.sender]=(10**tier).mul(adj);
_token.mint(msg.sender,amount[msg.sender]);    //replace transfer with mint
principal[msg.sender]=amount[msg.sender].mul(11);
principal[msg.sender]=principal[msg.sender].div(10);
pending[msg.sender]=true;    
time[msg.sender]=block.timestamp;
if(tier==creditsc_c[msg.sender])
_match[msg.sender]==true;
}
//repayment rate calc: 1-(defults[msg.sender]/(repayed[msg.sender]+defults[msg.sender]))
function returnloan() public returns(bool){
 require(pending[msg.sender]=true);
 if(block.timestamp.sub(time[msg.sender])>420000){
     creditsc_uc[msg.sender]=0;
     creditsc_c[msg.sender]=0;
     defults[msg.sender]+=1;
     if(friend[msg.sender]!=address(0)){
         creditsc_c[friend[msg.sender]]=0;
         creditsc_uc[friend[msg.sender]]=0;
         friend[msg.sender]=address(0);
     }
     creditsc_c[friend[msg.sender]]=0;
     meddefprinc[msg.sender]+=principal[msg.sender];
     meddefprinc[msg.sender]/=2;
     return false;
 }
 else{
require(token.allowance(msg.sender,address(this))==principal[msg.sender],"please approve required amount");
uint interest=principal[msg.sender].sub(amount[msg.sender]);
//uint burning=80;
//uint treasurym=15;
//uint ownerm=5;

//ducjdnc
require(interest+amount[msg.sender]==principal[msg.sender],"math error");

//token.transferFrom(msg.sender,_owner,interest.mul(ownerm.div(100)));
token.transferFrom(msg.sender,treasury,interest.div(2));//mul(treasurym.div(100)));
_token.burn(msg.sender,interest.div(2));//mul(burning.div(100)));
_token.burn(msg.sender,amount[msg.sender]);
 //replace with burn //math to calc principal needs to be checked
 pending[msg.sender]=false;
 creditsc_uc[msg.sender]+=1;
 
 //decide if to increase credit score, (checks if under limit)
 if(creditsc_c[msg.sender]<lim && _match[msg.sender]==true){
 rounds[msg.sender]=rounds[msg.sender].add(1);
 _match[msg.sender]=false;
 //sets cooldown before next loan.
  cooldown[msg.sender]=10**creditsc_c[msg.sender];
 timer[msg.sender]=block.timestamp;  //marks time when last loan was returned  
 if (rounds[msg.sender]>=roundsreq[msg.sender]){
     creditsc_c[msg.sender]=creditsc_c[msg.sender].add(1);
     if(creditsc_c[msg.sender]>10){
     friend[msg.sender]=address(0);//no link after person reaches level 10.
     }
     roundsreq[msg.sender]=roundsreq[msg.sender].add(1);
     rounds[msg.sender]=0;
     
 }//second if
 
 }//first if
 repayed[msg.sender]+=1;
 

 return true;    
 
     
 }
}
//funtions after this are for testing purposes

function freemoney() public  payable{
    _token.mint(msg.sender,(1000*adj));
}
/*function setgovernor(address _governor) public only_owner returns(bool){
    
    governor=_governor;
    return true;
}// set governor contract*/
function increment(address pardonee)public{
    //require(msg.sender==allowedcon||msg.sender==allowedcon2,"you do not have permission to do this action.");
    creditsc_c[pardonee]=1;
    creditsc_uc[pardonee]=1;
    
}

function testtransfer() public{
    token.transferFrom(msg.sender,address(this),100);
}

}
    

