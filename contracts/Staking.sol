// SPDX-License-Identifier:MIT
pragma solidity ^0.8.4;

import "./DegenToken.sol";

contract Staking is DegenToken {

    struct StakeData {
        uint stakedAmount;
        uint noOfDays;
        uint yearLater;
    }

    mapping(address => StakeData) stakes;

    function stake(uint _days) external payable {
        require(msg.value > 0, "You can't stake zero value");
        require(_days > 7, "staking period can't be less than 7 days");

        StakeData storage sData = stakes[msg.sender];
        sData.stakedAmount += msg.value;
        sData.noOfDays = block.timestamp + (_days * 1 days);
        sData.yearLater = block.timestamp + 365 days;

        mint(msg.value * 10 ** 18);
    }

    function withdraw() external {
        StakeData memory userStake = stakes[msg.sender];

        require(block.timestamp > userStake.noOfDays, "staking period not reached");
        require(userStake.stakedAmount > 0, "you don't have a stake");

        uint calculatedYield = calculateYield(userStake.noOfDays, userStake.stakedAmount, userStake.yearLater);

        uint transferable = userStake.stakedAmount + calculatedYield;

        stakes[msg.sender].stakedAmount = 0;
        stakes[msg.sender].noOfDays = 0;

        payable(msg.sender).transfer(transferable);
    }

    function calculateYield(uint _days, uint stakedAmount, uint _yearLater) private pure returns (uint yield) {
        uint daysQuotient = _days/_yearLater;
        yield = daysQuotient * stakedAmount;
    }
}