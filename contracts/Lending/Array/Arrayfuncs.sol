pragma solidity ^0.8.7;
contract Arrayfuncs{
function getmedian(uint[] memory amts) pure public returns(uint median){
uint mdl=amts.length/2;
median=amts[mdl];
return median;
}
function sortA(uint[] memory amts) pure public {
uint i;
uint tstr;//temporary storage
for(i=(amts.length-1);i>0;i--){
if(amts[i]<amts[i-1]){
    tstr=amts[i];
    amts[i]=amts[i-1];
    amts[i-1]=tstr;
}
}
}
}

interface IArrayfuncs{
function getmedian(uint[] memory amts) external returns(uint median);
function sortA(uint[] memory amts) external;
}
