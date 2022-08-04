// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;



contract Owner {
    address owner;
    
    constructor(){
        owner = msg.sender;
    }

    function changeOwner(address newOwner) external onlyOwner returns(bool) {
        owner = newOwner;
        return true;
    }
   
   modifier onlyOwner(){
       require(owner == msg.sender , "ERROR: CALLER IS NOT OWNER");
       _;
   }
}