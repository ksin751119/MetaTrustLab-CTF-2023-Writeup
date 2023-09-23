import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
describe("BytecodeVault", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployOneYearLockFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, someone] = await ethers.getSigners();

    const BytecodeVault = await ethers.getContractFactory("BytecodeVault");
    const vault = await BytecodeVault.connect(owner).deploy();

    return { vault, owner, someone};
  }

  describe("Solve Challenges", function () {
    it("solve", async function () {
      const { vault, owner, someone } = await loadFixture(deployOneYearLockFixture);
      console.log("owner", await vault.owner());

      expect(await vault.owner()).to.equal(await owner.getAddress());
    });


  });


});
