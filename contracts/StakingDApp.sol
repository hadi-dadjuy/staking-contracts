// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "./interfaces/IERC20.sol";
import "./Owner.sol";

contract StakingDApp is Owner{

    IERC20 nt; // platform's native token

    uint public baseStakingPeriod = 15 seconds; // yearly staking
    uint public baseRawardShare = 8; // staking share per year


    mapping (address => Staker)  stakers;

    struct Staker{
        uint valueStaked;
        uint stakingPeriod;
        uint stakedAt;
        uint rewardShare;
        bool staked;
    }

    constructor(address ntAddress) Owner(){
        nt = IERC20(ntAddress);
    }


    function stake() external payable notStaked notZeroValue{
        Staker memory staker= Staker({
            valueStaked: msg.value,
            stakingPeriod:baseStakingPeriod,
            stakedAt:block.timestamp,
            rewardShare: baseRawardShare,
            staked:true
        });
        stakers[msg.sender] = staker;
        uint share = msg.value / baseRawardShare;
        nt.transfer(msg.sender, share);
        emit Staked(msg.sender,msg.value,share);

    }

    function getTimer() external view returns(uint){
        Staker storage staker = stakers[msg.sender];
        uint age=block.timestamp - staker.stakedAt;
        if(age >= baseStakingPeriod){
            return 0;
        }
       return baseStakingPeriod - age;
    }
    function unstake() external staked returns(uint){
      Staker memory staker = stakers[msg.sender];
      staker.staked = false;
      uint value= staker.valueStaked;
      staker.valueStaked =0;
      stakers[msg.sender] = staker;
      payable(msg.sender).transfer(value);
      return value;
    }

    function getRewardBalance() external view returns(uint){
        return nt.balanceOf(msg.sender);
    }
    function isStaked() external view returns(bool) {

      return stakers[msg.sender].staked;
    }
    function valueStaked() external view returns(uint) {

      return stakers[msg.sender].valueStaked;
    }


    function changeBaseInfo(uint _baseStakingPeriod , uint _baseRewardShare) external onlyOwner returns(bool){
        baseStakingPeriod = _baseStakingPeriod;
        baseRawardShare = _baseRewardShare;
        return true;
    }



    event Staked(address staker, uint amount,uint reward);


    modifier notStaked(){
        require(!stakers[msg.sender].staked , "ERROR: YOU ARE ALREADY STAKING!");
        _;
    }

    modifier staked(){
        require(stakers[msg.sender].staked , "ERROR: YOU ARE NOT STAKING!");
        _;
    }

    modifier notZeroValue(){
        require(msg.value > 0 , "ERROR: VALUE IS ZERO!");
        _;
    }




}
