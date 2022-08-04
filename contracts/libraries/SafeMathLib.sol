// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

library SafeMath{

    // safe addition function for uint data type
    function add(uint x, uint y) internal pure returns(uint){
        unchecked{
            uint result = x + y;
            require(result >= x , "ERROR: Addition owerflow!");
            return result;
        }
    }

    // safe subtraction function for uint data type
    function sub(uint x, uint y) internal pure returns(uint){
        unchecked{
            require(x >= y , "ERROR: Subtraction underflow!");
            uint result = x - y;
            return result;
        }
    }

    // safe multiplication function for uint data type
    function mul(uint x, uint y) internal pure returns(uint){
        unchecked {
            if( x == 0 || y == 0) return 0;
            uint result = x * y;
            require(result / x == y , "ERROR: Multiplication overflow!");
            return result;
        }
    }

    // safe division function for uint data type
    function div(uint x, uint y) internal pure returns(uint){
        unchecked{
            require(y > 0 , "ERROR: Division by zero!");
            return x / y;
        }
    }

    // safe modulo function for uint data type
    function mod(uint x, uint y) internal pure returns(uint){
        unchecked{
            require(y > 0 , "ERROR: Modulo by zero!");
             return x % y;
        }
    }

    // safe increment function
    function inc(uint value) internal pure returns(uint){
        return add(value , 1);
    }

    // safe decrement function
    function dec(uint value) internal pure returns(uint){
        return sub(value , 1);
    }
    
}