// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;


interface ILoaning{
    function takeloan(uint) external;
    function returnloan(uint) external returns(bool);
    function increment(address) external;
    function creditsc_c(address) external returns(uint);
    function creditsc_uc(address) external returns(uint);
    function pending(address) external returns(bool);
    function cooldown(address) external returns(uint);
    
    
}
