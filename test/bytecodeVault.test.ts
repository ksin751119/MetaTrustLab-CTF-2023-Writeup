import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';
import { Wallet } from 'ethers';
describe('BytecodeVault', function () {
  let owner: Wallet;
  let user: Wallet;
  let vault: any;
  let solver: any;

  async function deployOneYearLockFixture() {
    // Contracts are deployed using the first signer/account by default
    [owner, user] = await (ethers as any).getSigners();
    vault = await (await ethers.getContractFactory('BytecodeVault'))
      .connect(owner)
      .deploy({ value: ethers.parseEther('1') });
    expect(await vault.isSolved()).to.be.false;
    console.log('vault', await vault.getAddress());
    console.log('owner', await owner.getAddress());
    console.log('user', await user.getAddress());

    // Get solver bytecode and abi
    const BytecodeVaultSolver = await ethers.getContractFactory(
      'BytecodeVaultSolver'
    );
    const abi = BytecodeVaultSolver.interface.formatJson();
    let bytecode: any = BytecodeVaultSolver.bytecode;

    // Replace codesize, need to find out from https://www.evm.codes/playground?fork=shanghai
    bytecode = bytecode.replace('015e', '0163');

    // Replace fake vault address in bytecode
    bytecode = bytecode.replace(
      new RegExp('DDdDddDdDdddDDddDDddDDDDdDdDDdDDdDDDDDDd', 'gi'),
      (await vault.getAddress()).replaceAll('0x', '')
    );

    // Add sequence to code
    bytecode = bytecode + 'deadbeef';

    // Make code length odd
    bytecode = bytecode + 'dd';

    // Create solver contract by newbytecode
    const contractInstance = new ethers.ContractFactory(abi, bytecode, owner);
    solver = await contractInstance.deploy();
    const deploymentTx = await solver.deploymentTransaction();
    console.log('inputData', deploymentTx.data);
  }

  beforeEach(async function () {
    await loadFixture(deployOneYearLockFixture);
  });

  it('solve', async function () {
    await solver.solve();
    expect(await vault.isSolved()).to.be.true;
  });
});
