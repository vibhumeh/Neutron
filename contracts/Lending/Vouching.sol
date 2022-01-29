// SPDX-License-Identifier: MIT
//vouchee -blacklisted person who is being vouched for by a high level person.
pragma solidity 0.8.7;
import "./ILoaning.sol";
    

//vouch contract
contract vouching{
    //friend is the link between the vouchee and the vouch giver so you know who to penalise incase of second defult
    mapping (address=>address) public friend;
    //banking is the main krredit bank contract address
    address bank;
    ILoaning loans;
    constructor(address banking) {
        bank=banking;
        loans=ILoaning(bank);
        
    }
    //vouch function begins here, it only takes address of the vouch reciever.
    function vouch(address vouchee) public returns (bool success){
        //person cannot have a pending loan.
        require(loans.pending(msg.sender)==false);

        //checks if his level is high enough (6 is dummy num)
        require(loans.creditsc_c(msg.sender)>=6,"your level is too low");
        //makes sure the receiver lev is at 0 so this feature cannot increase level of non-zero ppl
        require(loans.creditsc_c(vouchee)==0,"vouchee level is not 0");
        //tags person who vouched for vouchee
        friend[vouchee]=msg.sender;
        //increases level and makes vouchee eligible for loans again
        loans.increment(vouchee);
        return true;
    }
}
