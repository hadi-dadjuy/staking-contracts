const ERC20 = artifacts.require('ERC20')
const StakingDApp = artifacts.require('StakingDApp')
const truffleAssert = require('truffle-assertions')
const assert= require('assert')


let nt;
let ntAddress;
let stakingDApp;
let stakingDAppAddress;
contract('ERC20 contract', accounts =>{

    describe('native token deployment', async()=>{
        before(async()=>{
            nt = await ERC20.new('Native Token', 'NT' , toWei(21000000))
        })
        it('should be deployed successfully',async()=>{
            ntAddress = await nt.address;
            assert.notEqual(ntAddress,'')
            assert.notEqual(ntAddress,undefined)
        })
        it("should return ERC20 token name & symbol correctly",async()=>{
            const name= await nt.name()
            const symbol= await nt.symbol()
            assert.equal(name,"Native Token")
            assert.equal(symbol,"NT")
        })
        it("total supply should be equal to owner's balance",async()=>{
            const totalSupply= await nt.totalSupply()
            const balance= await nt.balanceOf(accounts[0])
            assert.equal(totalSupply.toString(),balance.toString())
        })

    })
    describe('StakingDApp contract', async()=>{
        before(async()=>{
            stakingDApp = await StakingDApp.new(ntAddress)
        })
        it('should be deployed successfully',async()=>{
            stakingDAppAddress = await stakingDApp.address;
            assert.notEqual(stakingDAppAddress,'')
            assert.notEqual(stakingDAppAddress,undefined)
        })
        it('should transfer all NT tokens to contract',async()=>{
            const totalSupply= await nt.totalSupply()
            await nt.transfer(stakingDAppAddress ,totalSupply )
            const contractBalance = await nt.balanceOf(stakingDAppAddress)
            assert.equal(contractBalance.toString(),totalSupply.toString())
        })
        it('should stake successfully',async()=>{
            const beforeStaking = await stakingDApp.isStaking({from: accounts[1]})
            await stakingDApp.stake({from:accounts[1],value:toWei(1)})
            const afterStaking = await stakingDApp.isStaking({from: accounts[1]})
            assert.notEqual(beforeStaking,afterStaking)
        })
        it('should successfully get the NT token balance for staker',async()=>{
            const staker = await stakingDApp.getStaker({from:accounts[1]})
            const share = staker['valueStaked'] / staker['rewardShare'];
            const balance = await nt.balanceOf(accounts[1])
            assert.equal(balance , share)
        })

    })
})












function toWei(number){
    return web3.utils.toWei(number.toString())
}
