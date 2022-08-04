const ERC20 = artifacts.require('ERC20')
const StakingDApp = artifacts.require('StakingDApp')

module.exports = async function deploy(deployer, network, accounts){
    // deploy native token
    await deployer.deploy(ERC20 , 'Native Token', 'NT' , toWei(21000000))
    const nt = await ERC20.deployed()
   
    // deploy StakingDApp contract
    await deployer.deploy(StakingDApp , nt.address)
    stakingDApp = await StakingDApp.deployed()

    // get native token's total supply and sent it back to StakingDApp contract
    const totalSupply = await nt.balanceOf(accounts[0])
    await nt.transfer(stakingDApp.address , totalSupply.toString())

}

function toWei(number){
    return web3.utils.toWei(number.toString())
}