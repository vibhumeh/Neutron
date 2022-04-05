pragma solidity 0.8.7;
/*
mapping (address=>uint) public P2;         D
mapping (address=>uint) private Rrate;     D
mapping (address=>uint) private Drate;     D
mapping (address=> uint) private Ltotal;   D
mapping (address=> uint) private Dtotal;   D
mapping (address=> uint) private defexpo;  D
mapping (address=>uint) private medianD;   D
mapping (address=>uint[]) private princeD; D
mapping (address=>uint) private medianL;   D
mapping (address=>uint[]) private princeL; D
mapping (address => bool) private _match; //checks if the loan taker has taken the highest teir loan availible to them D
mapping (address =>uint) private timer; // stores the time when loanee returned last loan [changed to Ldate]D
mapping (address=>uint) public cooldown; [deleted][normal constant]D
mapping (address=> uint) public creditsc_c; // capped credit score, stops @20 D
mapping (address=>uint) public defults;    D
mapping (address=>uint) public repayed;    D
mapping (address =>uint) rounds; //[deleted]
mapping (address =>uint) roundsreq; // [deleted]
mapping (address=>uint) public creditsc_uc; // uncapped credit score, can go beyond 20, D
mapping (address =>bool) public pending; //if loan not returned yet, true.D
mapping (address => uint) amount; //amount loaned D
mapping (address => uint) meddefprinc;     D
mapping (address=> uint ) public principal;//money required to be repayed.
mapping (address => uint) time;D
*/
contract Credits{


struct Credit_card{
//taking loan
uint creditsc_c;
uint creditsc_uc; //
uint _match;

uint amount;
//paying loan
uint pending;
uint Ldate;
uint time;
//DEBT CALC
uint[] princeD;
uint[] princeL;
uint medianL;
uint medianD;
uint defexpo;
uint Dtotal;
uint Drate;
uint Rrate;
uint Ltotal;
uint defults;
uint repayed;
uint meddefprinc;
uint P2;


}

mapping (uint256=>Credit_card) ID;
mapping (address=>bool) owns_card;
mapping (address=>uint256) C_owner;


uint total_Cards;


function CreateCard() public returns(bool){
require(owns_card[msg.sender]==false,'you already own a credit card');
total_Cards+=1;
C_owner[msg.sender]=total_Cards;
owns_card[msg.sender]=true;
return true;
}

function transferCard(address to) public returns(bool){
require(owns_card[to]==false,"The person you are trying to to transfer to already has a credit card");
C_owner[to]=C_owner[msg.sender];
owns_card[to]=true;
C_owner[msg.sender]=0;
owns_card[msg.sender]=false;
return true;
}

function burncard() public returns(bool){
ID[C_owner[msg.sender]]=ID[0];
C_owner[msg.sender]=0;
owns_card[msg.sender]=false;
return true;
}

function CardOf(address addr) public returns(uint) {
require(owns_card[addr]==true,"address does not own a credit card");
return C_owner[addr];


}
}
