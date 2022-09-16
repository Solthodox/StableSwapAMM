const {expect} = require("chai")
const {ethers} = require("hardhat")

const toEther = (n)=> ethers.utils.parseEther(n.toString() , "ether")

describe("Stable-Swap" , ()=>{
    let curve 
    let dai, usdt, usdc
    let deployer
    beforeEach(async ()=>{
        // Deployment
        const accounts = await ethers.getSigners()
        deployer = accounts[0]
        const Dai = await ethers.getContractFactory("Dai")
        const Usdt = await ethers.getContractFactory("Usdt")
        const Usdc = await ethers.getContractFactory("Usdc")

        dai = await Dai.deploy()
        usdt = await Usdt.deploy()
        usdc = await Usdc.deploy()

        const Curve = await ethers.getContractFactory("StableSwap")
        curve = await Curve.deploy(dai.address , usdc.address , usdt.address)

        // Approvals

        await  dai.approve(curve.address , toEther(10000))
        await  usdc.approve(curve.address , toEther(10000))
        await  usdt.approve(curve.address , toEther(10000))

    })

    describe("Add Liquidity" , ()=>{
        it("Should mint shares after adding liquidity" , async()=>{
            await curve.addLiquidity([toEther(100),toEther(100),toEther(100)],0)
            const shares = await curve.balanceOf(deployer.address)
            expect(shares).to.be.greaterThan(0)
        })
    })

    describe("Swap" ,()=>{
        it("Should get low slippage" , async()=>{
            const balancBefore = await usdc.balanceOf(deployer.address)
            await curve.swap(0,1, toEther(40) , toEther(39))
            const balanceAfter = await usdc.balanceOf(deployer.address)
            const amountOut = balanceAfter - balancBefore
            console.log("Amount out :" , amountOut)
            expect(amountOut.to.be.greaterThan(39))

        })
    } )

  
})